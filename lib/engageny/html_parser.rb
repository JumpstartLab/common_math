require "cgi"

module Engageny
  class HtmlParser
    STUDENT_SECTION_PATTERN = /\AName\s+Date/

    def initialize(html)
      @html = html
      @head_html, @sections, @tail_html = split_document
    end

    attr_reader :head_html, :tail_html

    # Returns { lesson_plan:, problem_set:, exit_ticket:, homework: }
    def parse_lesson
      student_indices = find_student_section_indices
      return all_as_lesson_plan if student_indices.empty?

      lesson_plan_html = join_sections(0...student_indices[0])

      case student_indices.length
      when 1
        {
          lesson_plan: lesson_plan_html,
          problem_set: join_sections(student_indices[0]..last_index),
          exit_ticket: nil,
          homework: nil
        }
      when 2
        {
          lesson_plan: lesson_plan_html,
          problem_set: join_sections(student_indices[0]...student_indices[1]),
          exit_ticket: join_sections(student_indices[1]..last_index),
          homework: nil
        }
      else
        {
          lesson_plan: lesson_plan_html,
          problem_set: join_sections(student_indices[0]...student_indices[1]),
          exit_ticket: join_sections(student_indices[1]...student_indices[2]),
          homework: join_sections(student_indices[2]..last_index)
        }
      end
    end

    def parse_single_document
      @html
    end

    # Reconstruct the full document from stored parts.
    def self.reconstruct(head_html, tail_html, *section_htmls)
      "#{head_html}#{section_htmls.compact.join}#{tail_html}"
    end

    # Wrap a single component as a standalone renderable page.
    def self.wrap_section(head_html, section_html)
      "#{head_html}#{section_html}</body></html>"
    end

    private

    def split_document
      # Find the boundary between head and body content
      body_match = @html.match(/\A(.*?<body[^>]*>)(.*)\z/m)
      return ["", [], ""] unless body_match

      head = body_match[1]
      body = body_match[2]

      # Find each Section div start position
      section_starts = []
      body.scan(/<div class="Section_\d+">/) do
        section_starts << Regexp.last_match.begin(0)
      end

      # Find closing body tag
      body_close = body.index("</body>") || body.length

      if section_starts.empty?
        return [head + body[0...body_close], [], body[body_close..]]
      end

      # Head includes everything up to and including the first section's start
      full_head = head + body[0...section_starts[0]]

      # Split body into sections
      sections = []
      section_starts.each_with_index do |start_pos, i|
        end_pos = i + 1 < section_starts.length ? section_starts[i + 1] : body_close
        sections << body[start_pos...end_pos]
      end

      tail = body[body_close..]

      [full_head, sections, tail]
    end

    def find_student_section_indices
      indices = []
      @sections.each_with_index do |content, i|
        text = strip_tags(content)
        first_100_chars = text[0, 100] || ""
        if first_100_chars.match?(STUDENT_SECTION_PATTERN)
          indices << i
        end
      end
      indices
    end

    def join_sections(range)
      @sections[range].join
    end

    def last_index
      @sections.length - 1
    end

    def all_as_lesson_plan
      {
        lesson_plan: @sections.join,
        problem_set: nil,
        exit_ticket: nil,
        homework: nil
      }
    end

    def strip_tags(html)
      text = html.gsub(/<style[^>]*>.*?<\/style>/m, "")
      text = text.gsub(/<[^>]+>/, " ")
      text = CGI.unescapeHTML(text)
      text.gsub(/[\s\u00a0]+/, " ").strip
    end
  end
end
