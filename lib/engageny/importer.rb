module Engageny
  class Importer
    BASE_PATH = Rails.root.join("data/engageny/grade-5-html")

    def initialize(base_path: BASE_PATH)
      @base_path = Pathname.new(base_path)
    end

    def import_all
      grade_dirs.each { |dir| import_grade(dir) }
    end

    private

    def grade_dirs
      @base_path.children.select(&:directory?).sort
    end

    def import_grade(dir)
      grade_number = extract_grade_number(dir.basename.to_s)
      return unless grade_number

      grade = Grade.find_or_create_by!(number: grade_number) do |g|
        g.title = "Grade #{grade_number}"
      end
      Rails.logger.info "Imported Grade #{grade_number}"

      module_dirs(dir).each_with_index do |mod_dir, i|
        import_module(grade, mod_dir, position: i + 1)
      end
    end

    def module_dirs(grade_dir)
      grade_dir.children.select(&:directory?).sort
    end

    def import_module(grade, dir, position:)
      module_number = extract_module_number(dir.basename.to_s)
      return unless module_number

      # Find the actual content directory (nested Module N/)
      content_dir = find_content_dir(dir)
      return unless content_dir

      overview_html = load_module_overview(content_dir)
      title = extract_module_title(overview_html) || "Module #{module_number}"

      content_module = grade.content_modules.find_or_create_by!(number: module_number) do |m|
        m.title = title
        m.overview_html = overview_html
        m.position = position
      end
      Rails.logger.info "  Imported Module #{module_number}: #{title}"

      import_assessments(content_module, content_dir)
      import_topics(content_module, content_dir)
    end

    def import_assessments(content_module, content_dir)
      assessment_dir = content_dir.children.find { |d| d.directory? && d.basename.to_s.include?("Assessment") }
      return unless assessment_dir

      assessment_dir.glob("*.html").sort.each do |file|
        assessment_type = if file.basename.to_s.include?("mid")
          "mid_module"
        elsif file.basename.to_s.include?("end")
          "end_of_module"
        else
          next
        end

        html = File.read(file)
        content_module.assessments.find_or_create_by!(assessment_type: assessment_type) do |a|
          a.content_html = html
        end
        Rails.logger.info "    Imported #{assessment_type} assessment"
      end
    end

    def import_topics(content_module, content_dir)
      lessons_dir = content_dir.children.find { |d| d.directory? && d.basename.to_s.include?("Lesson") }
      return unless lessons_dir

      topic_dirs = lessons_dir.children.select(&:directory?).sort
      topic_dirs.each_with_index do |topic_dir, i|
        import_topic(content_module, topic_dir, position: i + 1)
      end
    end

    def import_topic(content_module, dir, position:)
      letter = extract_topic_letter(dir.basename.to_s)
      return unless letter

      overview_file = dir.glob("*overview*").first
      overview_html = overview_file ? File.read(overview_file) : nil
      title = extract_topic_title(overview_html) || "Topic #{letter}"

      topic = content_module.topics.find_or_create_by!(letter: letter) do |t|
        t.title = title
        t.overview_html = overview_html
        t.position = position
      end
      Rails.logger.info "    Imported Topic #{letter}: #{title}"

      lesson_files = dir.glob("*lesson-*.html").reject { |f| f.basename.to_s.include?("overview") }.sort_by { |f| extract_lesson_number(f.basename.to_s) || 0 }

      lesson_files.each_with_index do |file, i|
        import_lesson(topic, file, position: i + 1)
      end
    end

    def import_lesson(topic, file, position:)
      lesson_number = extract_lesson_number(file.basename.to_s)
      return unless lesson_number

      html = File.read(file)
      normalized = HtmlNormalizer.normalize(html)
      parser = HtmlParser.new(normalized)
      parts = parser.parse_lesson

      objective = extract_objective(parts[:lesson_plan])

      # Store path relative to Rails root for portability
      relative_path = file.relative_path_from(Rails.root).to_s

      lesson = topic.lessons.find_or_create_by!(number: lesson_number) do |l|
        l.objective = objective
        l.position = position
        l.source_file = relative_path
        l.head_html = parser.head_html
        l.tail_html = parser.tail_html
      end

      if parts[:lesson_plan]
        lesson.create_lesson_plan!(content_html: parts[:lesson_plan]) unless lesson.lesson_plan
      end
      if parts[:problem_set]
        lesson.create_problem_set!(content_html: parts[:problem_set]) unless lesson.problem_set
      end
      if parts[:exit_ticket]
        lesson.create_exit_ticket!(content_html: parts[:exit_ticket]) unless lesson.exit_ticket
      end
      if parts[:homework]
        lesson.create_homework!(content_html: parts[:homework]) unless lesson.homework
      end

      Rails.logger.info "      Imported Lesson #{lesson_number} (PS=#{parts[:problem_set].present?} ET=#{parts[:exit_ticket].present?} HW=#{parts[:homework].present?})"
    end

    # --- Extraction helpers ---

    def find_content_dir(module_dir)
      # Handle nested "Module N/" directory
      children = module_dir.children.select(&:directory?)
      nested = children.find { |d| d.basename.to_s.match?(/^Module\s+\d+$/i) }
      nested || module_dir
    end

    def extract_grade_number(name)
      match = name.match(/Grade\s+(\d+)/i)
      match && match[1].to_i
    end

    def extract_module_number(name)
      match = name.match(/Module\s+(\d+)/i)
      match && match[1].to_i
    end

    def extract_topic_letter(name)
      match = name.match(/Topic-([A-Z])/i)
      match && match[1].upcase
    end

    def extract_lesson_number(name)
      match = name.match(/lesson-(\d+)/i)
      match && match[1].to_i
    end

    def extract_objective(html)
      return nil unless html
      text = strip_tags(html)
      # Match "Objective:" then capture until "Suggested" or "Sugges t ed" (Aspose spacing artifact)
      match = text.match(/Objective:\s*(.+?)(?:Sugges\s*t\s*ed|Suggested|$)/m)
      return nil unless match
      match[1].strip.gsub(/\s+/, " ")[0, 500]
    end

    def extract_module_title(html)
      return nil unless html
      text = strip_tags(html)
      # Module title appears after "GRADE N • MODULE N" heading
      match = text.match(/MODULE\s+\d+\s+(.+?)(?:OVERVIEW|Table of Contents)/mi)
      return nil unless match
      title = match[1].strip.gsub(/\s+/, " ")
      # Remove trailing "Module" artifact
      title.sub(/\s+Module\s*$/i, "")
    end

    def extract_topic_title(html)
      return nil unless html
      # Try extracting from the ny-h1 CSS class (the main heading)
      heading_match = html.match(/class="ny-h1"[^>]*>(.+?)<\/p>/m)
      if heading_match
        title = heading_match[1].gsub(/<[^>]+>/, "").strip
        title = CGI.unescapeHTML(title).gsub(/[\s\u00a0]+/, " ").strip
        return title unless title.empty?
      end
      # Fallback: regex on stripped text
      text = strip_tags(html)
      match = text.match(/Topic\s+[A-Z]\s+(.+?)(?:\d+\.\w+\.\d+|Focus|$)/m)
      return nil unless match
      match[1].strip.gsub(/\s+/, " ")
    end

    def load_module_overview(content_dir)
      overview_dir = content_dir.children.find { |d| d.directory? && d.basename.to_s.include?("Overview") }
      return nil unless overview_dir

      overview_file = overview_dir.glob("*overview*.html").first
      overview_file ? File.read(overview_file) : nil
    end

    def strip_tags(html)
      text = html.gsub(/<style[^>]*>.*?<\/style>/m, "")
      text = text.gsub(/<[^>]+>/, " ")
      text = CGI.unescapeHTML(text)
      text.gsub(/[\s\u00a0]+/, " ").strip
    end
  end
end
