require "test_helper"

class Interstandard::ClientTest < ActiveSupport::TestCase
  setup do
    @client = Interstandard::Client.new(base_url: "https://interstandard.example", api_key: "test-key")
  end

  test "submit posts rows and target_framework and returns the parsed submission" do
    stub_request(:post, "https://interstandard.example/api/v1/submissions")
      .with(
        headers: { "Authorization" => "Bearer test-key", "Content-Type" => "application/json" },
        body: { target_framework: "co-math-2020", rows: [ { item_id: "a", source_framework: "ccss-math", code: "5.NF.1" } ] }.to_json
      )
      .to_return(status: 202, body: { id: "sub-1", status: "queued", rows_total: 1, rows_done: 0 }.to_json, headers: { "Content-Type" => "application/json" })

    result = @client.submit([ { item_id: "a", source_framework: "ccss-math", code: "5.NF.1" } ], "co-math-2020")

    assert_equal "sub-1", result["id"]
    assert_equal "queued", result["status"]
  end

  test "fetch_report returns the parsed report" do
    stub_request(:get, "https://interstandard.example/api/v1/submissions/sub-1")
      .with(headers: { "Authorization" => "Bearer test-key" })
      .to_return(status: 200, body: { id: "sub-1", status: "done", rows: [] }.to_json, headers: { "Content-Type" => "application/json" })

    result = @client.fetch_report("sub-1")

    assert_equal "done", result["status"]
  end

  test "poll returns once status is done, backing off between attempts" do
    stub_request(:get, "https://interstandard.example/api/v1/submissions/sub-1")
      .to_return(
        { status: 200, body: { status: "queued" }.to_json },
        { status: 200, body: { status: "done", rows: [] }.to_json }
      )

    result = @client.poll("sub-1", timeout: 5, interval: 0.01)
    assert_equal "done", result["status"]
  end

  test "poll raises PollTimeout if the deadline passes before a terminal status" do
    stub_request(:get, "https://interstandard.example/api/v1/submissions/sub-1")
      .to_return(status: 200, body: { status: "queued" }.to_json)

    assert_raises(Interstandard::PollTimeout) { @client.poll("sub-1", timeout: 0.05, interval: 0.02, max_interval: 0.02) }
  end

  test "raises Unauthorized on a 401" do
    stub_request(:get, "https://interstandard.example/api/v1/submissions/sub-1")
      .to_return(status: 401, body: { error: { code: "invalid_api_key", message: "nope" } }.to_json)

    error = assert_raises(Interstandard::Unauthorized) { @client.fetch_report("sub-1") }
    assert_equal "nope", error.message
  end

  test "raises RateLimited on a 429 and captures Retry-After" do
    stub_request(:get, "https://interstandard.example/api/v1/submissions/sub-1")
      .to_return(status: 429, headers: { "Retry-After" => "30" }, body: { error: { code: "rate_limited", message: "slow down" } }.to_json)

    error = assert_raises(Interstandard::RateLimited) { @client.fetch_report("sub-1") }
    assert_equal 30, error.retry_after
  end

  test "raises RequestFailed with the error code on other non-2xx responses" do
    stub_request(:post, "https://interstandard.example/api/v1/submissions")
      .to_return(status: 422, body: { error: { code: "rows_required", message: "no rows" } }.to_json)

    error = assert_raises(Interstandard::RequestFailed) { @client.submit([], "co-math-2020") }
    assert_equal "rows_required", error.code
    assert_equal 422, error.status
  end

  test "raises Unauthorized without making a request when no api key is configured" do
    client = Interstandard::Client.new(base_url: "https://interstandard.example", api_key: nil)
    assert_raises(Interstandard::Unauthorized) { client.fetch_report("sub-1") }
  end
end
