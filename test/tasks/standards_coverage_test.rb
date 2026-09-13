require "test_helper"
require "rake"

class StandardsCoverageTaskTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("standards:coverage")
    Rake::Task["standards:coverage"].reenable

    @grade5 = Grade.create!(number: 5, title: "Grade 5")
    cm5 = @grade5.content_modules.create!(number: 1, title: "Module 1", position: 1)
    topic5 = cm5.topics.create!(letter: "A", title: "Topic A", position: 1)
    @lesson5_confirmed = topic5.lessons.create!(number: 1, position: 1)
    @lesson5_bare = topic5.lessons.create!(number: 2, position: 2)

    @grade6 = Grade.create!(number: 6, title: "Grade 6")
    cm6 = @grade6.content_modules.create!(number: 1, title: "Module 1", position: 1)
    topic6 = cm6.topics.create!(letter: "A", title: "Topic A", position: 1)
    @lesson6 = topic6.lessons.create!(number: 1, position: 1)

    standard = Standard.create!(code: "5.NF.1", domain: "d", description: "d", grade_level: 5)

    StateStandardTagging.create!(
      taggable: @lesson5_confirmed, standard: standard, target_framework: "co-math-2020",
      state_code: "CO.5.NF.1", relationship: "exact", review_state: "confirmed", retargeted_at: Time.current
    )
  end

  test "prints the fraction of grade 5 lessons with a confirmed code, per configured framework, by default" do
    out, = capture_io { Rake::Task["standards:coverage"].invoke }

    assert_match(%r{co-math-2020 \(grade 5\): 1/2 lessons \(50\.0%\)}, out)
    assert_match(%r{tx-teks-math \(grade 5\): 0/2 lessons \(0\.0%\)}, out)
    assert_no_match(/grade 6/, out)
  end

  test "accepts a specific grade" do
    out, = capture_io { Rake::Task["standards:coverage"].invoke("6") }

    assert_match(%r{co-math-2020 \(grade 6\): 0/1 lessons \(0\.0%\)}, out)
  end

  test "'all' prints every grade" do
    out, = capture_io { Rake::Task["standards:coverage"].invoke("all") }

    assert_match(/grade 5/, out)
    assert_match(/grade 6/, out)
  end
end
