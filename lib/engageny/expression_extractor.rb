require "zip"
require "nokogiri"
require "base64"
require_relative "math_converter"

module Engageny
  # Extracts math expressions from EngageNY DOCX files and stores them
  # as Expression records with OMML, MathML, and text representations.
  class ExpressionExtractor
    MATH_NS = "http://schemas.openxmlformats.org/officeDocument/2006/math"

    def initialize
      @converter = MathConverter.new
    end

    attr_reader :converter

    # Extract all expressions from a lesson's source DOCX and save as Expression records.
    def extract_for_lesson(lesson)
      docx_data = read_docx(lesson)
      return 0 unless docx_data

      doc_xml = extract_document_xml(docx_data)
      return 0 unless doc_xml

      doc = Nokogiri::XML(doc_xml)
      omaths = doc.xpath("//m:oMath", "m" => MATH_NS)
      return 0 if omaths.empty?

      count = 0
      omaths.each_with_index do |omath, i|
        omml_xml = omath.to_xml
        text = omath.xpath(".//m:t", "m" => MATH_NS).map(&:text).join(" ").strip

        result = @converter.convert(
          omml_xml,
          file: File.basename(lesson.source_file || "unknown"),
          context: "#{lesson.label} expression #{i + 1}"
        )

        status = if result[:mathml]
          result[:fixes]&.any? ? "fix_applied" : "converted"
        else
          "unconverted"
        end

        lesson.expressions.find_or_create_by!(position: i + 1) do |expr|
          expr.omml = omml_xml
          expr.mathml = result[:mathml]
          expr.text_representation = text
          expr.conversion_status = status
          expr.conversion_notes = {
            fixes: result[:fixes],
            error: result[:error]
          }.compact
        end

        count += 1
      end

      count
    end

    # Extract expressions for all lessons in the database.
    def extract_all
      total = 0
      Lesson.find_each do |lesson|
        extracted = extract_for_lesson(lesson)
        total += extracted
        print "." if extracted > 0
      end
      total
    end

    private

    def read_docx(lesson)
      source = lesson.source_file
      return nil unless source

      # Derive DOCX path from HTML path
      grade_num = lesson.topic.content_module.grade.number
      mod_num = lesson.topic.content_module.number
      zip_path = Rails.root.join(
        "..", "concept-research", "paper-math-companion", "resources", "engageny",
        "grade-#{grade_num}", "Grade #{grade_num} Module #{mod_num}.zip"
      )
      return nil unless zip_path.exist?

      docx_name = File.basename(source, ".html") + ".docx"

      Zip::File.open(zip_path.to_s) do |zip|
        entry = zip.entries.find { |e| e.name.end_with?(docx_name) && !e.name.include?("~") && !e.name.include?("Archived") }
        return nil unless entry
        entry.get_input_stream.read
      end
    end

    def extract_document_xml(docx_data)
      inner = Zip::File.open_buffer(docx_data)
      doc_entry = inner.find_entry("word/document.xml")
      return nil unless doc_entry
      doc_entry.get_input_stream.read
    end
  end
end
