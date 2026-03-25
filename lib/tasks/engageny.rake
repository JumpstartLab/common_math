namespace :engageny do
  desc "Import Grade 5 HTML content into the database"
  task import: :environment do
    require_relative "../engageny/html_parser"
    require_relative "../engageny/html_normalizer"
    require_relative "../engageny/importer"

    puts "Importing EngageNY content..."
    Engageny::Importer.new.import_all
    puts "Done."

    puts "\nSummary:"
    puts "  Grades: #{Grade.count}"
    puts "  Content Modules: #{ContentModule.count}"
    puts "  Topics: #{Topic.count}"
    puts "  Lessons: #{Lesson.count}"
    puts "  Lesson Plans: #{LessonPlan.count}"
    puts "  Problem Sets: #{ProblemSet.count}"
    puts "  Exit Tickets: #{ExitTicket.count}"
    puts "  Homeworks: #{Homework.count}"
    puts "  Assessments: #{Assessment.count}"
  end

  desc "Extract OMML math expressions from DOCXs and convert to MathML"
  task extract_math: :environment do
    require_relative "../engageny/expression_extractor"

    puts "Extracting math expressions..."
    extractor = Engageny::ExpressionExtractor.new
    total = extractor.extract_all
    puts "\nDone."

    puts "\nSummary:"
    puts "  Total expressions: #{Expression.count}"
    puts "  Converted: #{Expression.where(conversion_status: 'converted').count}"
    puts "  Fix applied: #{Expression.where(conversion_status: 'fix_applied').count}"
    puts "  Unconverted: #{Expression.where(conversion_status: 'unconverted').count}"

    manifest_path = Rails.root.join("tmp/expression-extraction-manifest.json")
    extractor.converter.write_manifest(manifest_path)
    puts "\nManifest written to #{manifest_path}"
  end

  desc "Validate round-trip: reconstruct each lesson and compare to normalized source"
  task validate: :environment do
    require_relative "../engageny/html_parser"
    require_relative "../engageny/html_normalizer"

    pass = 0
    fail = 0

    Lesson.includes(:lesson_plan, :problem_set, :exit_ticket, :homework, topic: :content_module)
          .find_each do |lesson|
      original = lesson.original_normalized_html
      if original.nil?
        puts "SKIP #{lesson.label}: source file not found (#{lesson.source_file})"
        next
      end

      reconstructed = lesson.reconstructed_html

      if original == reconstructed
        pass += 1
        print "."
      else
        fail += 1
        puts "\nFAIL #{lesson.label}"

        # Show first difference
        original.chars.each_with_index do |c, i|
          if reconstructed[i] != c
            puts "  First diff at byte #{i}"
            puts "  Original:      #{original[[i - 30, 0].max..i + 30].inspect}"
            puts "  Reconstructed: #{reconstructed[[i - 30, 0].max..i + 30].inspect}"
            break
          end
        end
      end
    end

    puts "\n\nResults: #{pass} passed, #{fail} failed out of #{pass + fail} lessons"
  end

  desc "Visual comparison: screenshot HTML rendering and compare against original PDF"
  task :compare, [:lesson_id] => :environment do |_t, args|
    require_relative "../engageny/html_parser"
    require_relative "../engageny/html_normalizer"
    require "ferrum"
    require "fileutils"

    lesson_id = args[:lesson_id] || Lesson.joins(topic: :content_module).where(content_modules: { number: 2 }).first.id
    lesson = Lesson.includes(:lesson_plan, :problem_set, :exit_ticket, :homework, topic: { content_module: :grade }).find(lesson_id)

    output_dir = Rails.root.join("tmp/compare-#{lesson.label}")
    FileUtils.mkdir_p(output_dir)

    puts "Comparing #{lesson.label}..."

    # 1. Extract original PDF from archive
    grade_num = lesson.topic.content_module.grade.number
    mod_num = lesson.topic.content_module.number
    zip_path = Rails.root.join("..", "concept-research", "paper-math-companion", "resources", "engageny",
      "grade-#{grade_num}", "Grade #{grade_num} Module #{mod_num}.zip")

    if zip_path.exist?
      pdf_name = File.basename(lesson.source_file, ".html") + ".pdf"
      listing = `unzip -l "#{zip_path}" 2>/dev/null | grep "#{pdf_name}" | grep -v Archived`.strip
      unless listing.empty?
        zip_entry = listing.split(/\s+/, 4).last
        system("unzip", "-o", zip_path.to_s, zip_entry, "-d", output_dir.to_s, out: File::NULL, err: File::NULL)
        extracted = output_dir.join(zip_entry)
        if extracted.exist?
          FileUtils.cp(extracted, output_dir.join("original.pdf"))
          system("pdftoppm", output_dir.join("original.pdf").to_s, output_dir.join("original").to_s, "-png", "-r", "150")
          puts "  Original PDF: #{Dir.glob(output_dir.join('original-*.png')).count} pages"
        end
      end
    end

    # 2. Screenshot our HTML rendering
    html = lesson.reconstructed_html
    page_css = Rails.root.join("app/assets/stylesheets/engageny_pages.css").read
    html = html.sub("</head>", "<style>#{page_css}</style></head>").sub("<body", '<body class="engageny-pages"')

    browser = Ferrum::Browser.new(
      browser_path: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
      headless: "new",
      timeout: 30,
      window_size: [1000, 1400]
    )

    browser.goto("data:text/html;charset=utf-8,#{ERB::Util.url_encode(html)}")
    browser.network.wait_for_idle
    sleep 2
    browser.screenshot(path: output_dir.join("html-full.png").to_s, full: true)
    browser.quit
    puts "  HTML screenshot saved"

    puts "\nOutput in: #{output_dir}"
    puts "  open #{output_dir}/original-01.png  # original page 1"
    puts "  open #{output_dir}/html-full.png     # our HTML rendering"
  end
end
