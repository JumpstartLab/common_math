require "test_helper"

class Standards::RetargeterTest < ActiveSupport::TestCase
  setup do
    @grade = Grade.create!(number: 5, title: "Grade 5")
    @content_module = @grade.content_modules.create!(number: 1, title: "Module 1", position: 1)
    @topic = @content_module.topics.create!(letter: "A", title: "Topic A", position: 1)
    @lesson = @topic.lessons.create!(number: 1, position: 1)

    @matched_standard = Standard.create!(code: "5.NF.1", domain: "d", description: "d", grade_level: 5)
    @unmatched_standard = Standard.create!(code: "5.NF.2", domain: "d", description: "d", grade_level: 5)

    @lesson.standard_taggings.create!(standard: @matched_standard)
    @lesson.standard_taggings.create!(standard: @unmatched_standard)
  end

  def matched_item_id
    "Lesson:#{@lesson.id}:5.NF.1"
  end

  def unmatched_item_id
    "Lesson:#{@lesson.id}:5.NF.2"
  end

  def stub_submission(rows_report)
    stub_request(:post, "https://interstandard.example/api/v1/submissions")
      .to_return(status: 202, body: { id: "sub-1", status: "queued" }.to_json, headers: { "Content-Type" => "application/json" })

    stub_request(:get, "https://interstandard.example/api/v1/submissions/sub-1")
      .to_return(status: 200, body: { id: "sub-1", status: "done", rows: rows_report }.to_json, headers: { "Content-Type" => "application/json" })
  end

  def client
    Interstandard::Client.new(base_url: "https://interstandard.example", api_key: "test-key")
  end

  test "stores only confirmed exact/grade_shifted results and reports the rest" do
    stub_submission([
      {
        "item_id" => matched_item_id,
        "status" => "matched",
        "results" => [
          { "framework" => "co-math-2020", "code" => "CO.5.NF.1", "statement" => "does fractions",
            "relationship" => "exact", "confidence" => 1.0, "review_state" => "confirmed", "disputed" => false,
            "provenance" => { "kind" => "case_import", "ref" => "assoc-1" } },
          { "framework" => "co-math-2020", "code" => "CO.5.NF.9", "statement" => "unconfirmed one",
            "relationship" => "exact", "confidence" => 0.4, "review_state" => "proposed", "disputed" => false,
            "provenance" => { "kind" => "ai_proposal", "ref" => "prop-1" } }
        ]
      },
      { "item_id" => unmatched_item_id, "status" => "no_confirmed_match", "results" => [] }
    ])

    report = Standards::Retargeter.new(client: client).call("co-math-2020")

    assert_equal 1, report.stored
    assert_equal [ unmatched_item_id ], report.no_confirmed_match
    assert_empty report.invalid

    tagging = StateStandardTagging.sole
    assert_equal @lesson, tagging.taggable
    assert_equal @matched_standard, tagging.standard
    assert_equal "co-math-2020", tagging.target_framework
    assert_equal "CO.5.NF.1", tagging.state_code
    assert_equal "exact", tagging.relationship
    assert_equal "confirmed", tagging.review_state
    assert_not tagging.disputed
    assert_equal "case_import", tagging.provenance
    assert_equal "assoc-1", tagging.edge_provenance_ref
  end

  test "invalid rows are reported and store nothing" do
    stub_submission([
      { "item_id" => matched_item_id, "status" => "invalid", "error" => "unknown code" },
      { "item_id" => unmatched_item_id, "status" => "no_confirmed_match", "results" => [] }
    ])

    report = Standards::Retargeter.new(client: client).call("co-math-2020")

    assert_equal 0, report.stored
    assert_equal [ { item_id: matched_item_id, error: "unknown code" } ], report.invalid
  end

  test "re-run marks a previously confirmed row stale when it no longer appears confirmed" do
    stub_submission([
      { "item_id" => matched_item_id, "status" => "matched", "results" => [
        { "framework" => "co-math-2020", "code" => "CO.5.NF.1", "statement" => "s",
          "relationship" => "exact", "confidence" => 1.0, "review_state" => "confirmed", "disputed" => false,
          "provenance" => { "kind" => "case_import", "ref" => "assoc-1" } }
      ] },
      { "item_id" => unmatched_item_id, "status" => "no_confirmed_match", "results" => [] }
    ])
    Standards::Retargeter.new(client: client).call("co-math-2020")
    assert_equal 1, StateStandardTagging.fresh.count

    stub_submission([
      { "item_id" => matched_item_id, "status" => "no_confirmed_match", "results" => [] },
      { "item_id" => unmatched_item_id, "status" => "no_confirmed_match", "results" => [] }
    ])
    report = Standards::Retargeter.new(client: client).call("co-math-2020")

    assert_equal 1, report.stale
    assert_equal 0, StateStandardTagging.fresh.count
    assert_equal 1, StateStandardTagging.stale.count
  end

  test "re-run with the same confirmed result upserts rather than duplicating" do
    result = { "framework" => "co-math-2020", "code" => "CO.5.NF.1", "statement" => "s",
               "relationship" => "exact", "confidence" => 1.0, "review_state" => "confirmed", "disputed" => false,
               "provenance" => { "kind" => "case_import", "ref" => "assoc-1" } }
    rows = [
      { "item_id" => matched_item_id, "status" => "matched", "results" => [ result ] },
      { "item_id" => unmatched_item_id, "status" => "no_confirmed_match", "results" => [] }
    ]

    stub_submission(rows)
    Standards::Retargeter.new(client: client).call("co-math-2020")
    stub_submission(rows)
    Standards::Retargeter.new(client: client).call("co-math-2020")

    assert_equal 1, StateStandardTagging.count
  end
end
