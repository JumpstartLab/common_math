require "test_helper"

module Engageny
  class FocusStandardTaggerTest < ActiveSupport::TestCase
    def focus_standards_html
      file_fixture("topic_overview_focus_standards.html").read
    end

    def unresolved_focus_standard_html
      file_fixture("topic_overview_unresolved_focus_standard.html").read
    end

    def build_topic(overview_html:, lesson_count: 2)
      grade = Grade.create!(number: 5, title: "Grade 5")
      content_module = grade.content_modules.create!(number: 1, title: "Module 1", position: 1)
      topic = content_module.topics.create!(letter: "A", title: "Topic A", position: 1, overview_html: overview_html)
      lesson_count.times do |i|
        topic.lessons.create!(number: i + 1, position: i + 1)
      end
      topic
    end

    def create_standard(code:, grade_level: 5, domain: "Number and Operations in Base Ten")
      Standard.create!(
        code: code,
        domain: domain,
        description: "Description for #{code}",
        grade_level: grade_level
      )
    end

    test "extract_codes finds CCSS codes inside ny-list-focusstandards markup" do
      codes = FocusStandardTagger.extract_codes(focus_standards_html)
      assert_equal %w[5.NBT.1 5.NBT.2], codes.sort
    end

    test "extract_codes returns empty array for blank html" do
      assert_equal [], FocusStandardTagger.extract_codes(nil)
      assert_equal [], FocusStandardTagger.extract_codes("")
    end

    test "extract_codes returns empty array when the focus-standards class is absent" do
      html = "<p class=\"ny-normal\">5.NBT.1 mentioned but not in the focus standards list</p>"
      assert_equal [], FocusStandardTagger.extract_codes(html)
    end

    test "extract_codes yields nothing and does not raise on malformed markup" do
      malformed = "<div class=\"ny-list-focusstandards\"><p>unterminated<div>"
      assert_nothing_raised { FocusStandardTagger.extract_codes(malformed) }

      binary_garbage = "<p class=\"ny-list-focusstandards\">\xFF\xFE not valid utf-8</p>".dup.force_encoding("ASCII-8BIT")
      assert_nothing_raised { FocusStandardTagger.extract_codes(binary_garbage) }
    end

    test "normalize strips an embedded cluster letter but leaves bare cluster codes alone" do
      assert_equal "5.NBT.1", FocusStandardTagger.normalize("5.NBT.1")
      assert_equal "5.NBT.1", FocusStandardTagger.normalize("5.NBT.A.1")
      assert_equal "5.NF.4a", FocusStandardTagger.normalize("5.NF.4a")
      assert_equal "5.NBT.A", FocusStandardTagger.normalize("5.NBT.A")
    end

    test "tag_topic! creates a tagging on the topic and on every lesson beneath it" do
      create_standard(code: "5.NBT.1")
      create_standard(code: "5.NBT.2")
      topic = build_topic(overview_html: focus_standards_html, lesson_count: 2)

      report = FocusStandardTagger.tag_topic!(topic)

      assert_equal 2, report.topic_taggings
      assert_equal 4, report.lesson_taggings # 2 standards x 2 lessons
      assert_empty report.unresolved

      assert_equal %w[5.NBT.1 5.NBT.2], topic.standards.reload.pluck(:code).sort
      topic.lessons.each do |lesson|
        assert_equal %w[5.NBT.1 5.NBT.2], lesson.standards.reload.pluck(:code).sort
      end
    end

    test "tag_topic! is idempotent on a second run" do
      create_standard(code: "5.NBT.1")
      create_standard(code: "5.NBT.2")
      topic = build_topic(overview_html: focus_standards_html, lesson_count: 2)

      FocusStandardTagger.tag_topic!(topic)
      second_report = FocusStandardTagger.tag_topic!(topic)

      assert_equal 0, second_report.topic_taggings
      assert_equal 0, second_report.lesson_taggings
      assert_equal 2, topic.standard_taggings.count
    end

    test "tag_topic! reports codes with no matching Standard row instead of dropping them" do
      topic = build_topic(overview_html: unresolved_focus_standard_html, lesson_count: 1)

      report = FocusStandardTagger.tag_topic!(topic)

      assert_equal 0, report.topic_taggings
      assert_equal 0, report.lesson_taggings
      assert_equal({ "5.NBT.A" => 1, "9.ZZ.1" => 1 }, report.unresolved)
    end

    test "tag_topic! returns an empty report for a topic with no overview html" do
      topic = build_topic(overview_html: nil, lesson_count: 1)

      report = FocusStandardTagger.tag_topic!(topic)

      assert_equal 0, report.topic_taggings
      assert_equal 0, report.lesson_taggings
      assert_empty report.unresolved
    end
  end
end
