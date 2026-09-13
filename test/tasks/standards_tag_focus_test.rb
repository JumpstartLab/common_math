require "test_helper"
require "rake"

class StandardsTagFocusTaskTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("standards:tag_focus")
    Rake::Task["standards:tag_focus"].reenable
  end

  def html_fixture(name)
    file_fixture(name).read
  end

  test "tags topics/lessons with resolvable standards and reports unresolved ones" do
    Standard.create!(code: "5.NBT.1", domain: "Number and Operations in Base Ten", description: "d", grade_level: 5)
    Standard.create!(code: "5.NBT.2", domain: "Number and Operations in Base Ten", description: "d", grade_level: 5)

    grade = Grade.create!(number: 5, title: "Grade 5")
    content_module = grade.content_modules.create!(number: 1, title: "Module 1", position: 1)

    tagged_topic = content_module.topics.create!(
      letter: "A", title: "Topic A", position: 1,
      overview_html: html_fixture("topic_overview_focus_standards.html")
    )
    tagged_topic.lessons.create!(number: 1, position: 1)

    unresolved_topic = content_module.topics.create!(
      letter: "B", title: "Topic B", position: 2,
      overview_html: html_fixture("topic_overview_unresolved_focus_standard.html")
    )

    content_module.topics.create!(letter: "C", title: "Topic C (no overview)", position: 3, overview_html: nil)

    out, = capture_io { Rake::Task["standards:tag_focus"].invoke }

    assert_equal 2, tagged_topic.standard_taggings.count
    assert_equal 0, unresolved_topic.standard_taggings.count

    assert_match(/Topics with overview HTML: 2/, out)
    assert_match(/Topics without overview HTML \(skipped\): 1/, out)
    assert_match(/Topic taggings created: 2/, out)
    assert_match(/Lesson taggings created: 2/, out)
    assert_match(/5\.NBT\.A \(1\)/, out)
    assert_match(/9\.ZZ\.1 \(1\)/, out)
  end
end
