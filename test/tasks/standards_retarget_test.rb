require "test_helper"
require "rake"

class StandardsRetargetTaskTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("standards:retarget")
    Rake::Task["standards:retarget"].reenable
    Rake::Task["standards:retarget_all"].reenable

    @grade = Grade.create!(number: 5, title: "Grade 5")
    content_module = @grade.content_modules.create!(number: 1, title: "Module 1", position: 1)
    topic = content_module.topics.create!(letter: "A", title: "Topic A", position: 1)
    @lesson = topic.lessons.create!(number: 1, position: 1)
    standard = Standard.create!(code: "5.NF.1", domain: "d", description: "d", grade_level: 5)
    @lesson.standard_taggings.create!(standard: standard)
    @item_id = "Lesson:#{@lesson.id}:5.NF.1"
  end

  def stub_submission_and_report(target_framework, rows_report)
    stub_request(:post, "#{Interstandard::BASE_URL}/api/v1/submissions")
      .with(body: hash_including("target_framework" => target_framework))
      .to_return(status: 202, body: { id: "sub-1", status: "queued" }.to_json, headers: { "Content-Type" => "application/json" })

    stub_request(:get, "#{Interstandard::BASE_URL}/api/v1/submissions/sub-1")
      .to_return(status: 200, body: { id: "sub-1", status: "done", rows: rows_report }.to_json, headers: { "Content-Type" => "application/json" })
  end

  test "standards:retarget stores only confirmed rows and prints a summary" do
    stub_submission_and_report("co-math-2020", [
      { "item_id" => @item_id, "status" => "matched", "results" => [
        { "framework" => "co-math-2020", "code" => "CO.5.NF.1", "statement" => "s", "relationship" => "exact",
          "confidence" => 1.0, "review_state" => "confirmed", "disputed" => false,
          "provenance" => { "kind" => "case_import", "ref" => "assoc-1" } }
      ] }
    ])

    with_interstandard_api_key("test-key") do
      out, = capture_io { Rake::Task["standards:retarget"].invoke("co-math-2020") }
      assert_match(/Target framework: co-math-2020/, out)
      assert_match(/Stored \(confirmed exact\/grade_shifted\) rows: 1/, out)
    end

    assert_equal 1, StateStandardTagging.count
    assert_equal "CO.5.NF.1", StateStandardTagging.first.state_code
  end

  test "standards:retarget reports a no_confirmed_match row and stores nothing for it" do
    stub_submission_and_report("co-math-2020", [
      { "item_id" => @item_id, "status" => "no_confirmed_match", "results" => [] }
    ])

    with_interstandard_api_key("test-key") do
      out, = capture_io { Rake::Task["standards:retarget"].invoke("co-math-2020") }
      assert_match(/Rows with no confirmed match: 1/, out)
      assert_match(/#{Regexp.escape(@item_id)}/, out)
    end

    assert_equal 0, StateStandardTagging.count
  end

  private

  # standards:retarget builds Interstandard::Client with no args, which
  # defaults to the Interstandard::API_KEY constant (nil in test unless a
  # real key is set) — swap it in for the duration of the block.
  def with_interstandard_api_key(key)
    original = Interstandard::API_KEY
    Interstandard.send(:remove_const, :API_KEY)
    Interstandard.const_set(:API_KEY, key)
    yield
  ensure
    Interstandard.send(:remove_const, :API_KEY)
    Interstandard.const_set(:API_KEY, original)
  end
end
