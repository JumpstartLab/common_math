require "net/http"
require "json"
require "uri"

module Interstandard
  # Base for every error this client raises. Rescue this to catch anything
  # that went wrong talking to Interstandard.
  class Error < StandardError; end

  # 401 from Interstandard: the API key is missing, malformed, or revoked.
  class Unauthorized < Error; end

  # 429 from Interstandard: either the per-key request rate or the
  # submission-frequency cap was exceeded. #retry_after, when the response
  # carried it, is seconds to wait before trying again.
  class RateLimited < Error
    attr_reader :retry_after

    def initialize(message, retry_after: nil)
      super(message)
      @retry_after = retry_after
    end
  end

  # Any other non-2xx response (422 validation errors, 404, 5xx, ...).
  class RequestFailed < Error
    attr_reader :status, :code

    def initialize(message, status:, code: nil)
      super(message)
      @status = status
      @code = code
    end
  end

  # #poll gave up before the submission reached a terminal status.
  class PollTimeout < Error; end

  # Thin client for the Interstandard translator API (docs/api.md in the
  # interstandard repo). Used by standards:retarget to submit CCSS taggings
  # for bulk retargeting onto a state framework and read back the report.
  class Client
    DEFAULT_OPEN_TIMEOUT = 10
    DEFAULT_READ_TIMEOUT = 30

    def initialize(base_url: Interstandard::BASE_URL, api_key: Interstandard::API_KEY)
      @base_url = base_url.to_s.chomp("/")
      @api_key = api_key
    end

    # rows: an array of { item_id:, source_framework:, code: } hashes.
    # Returns the parsed JSON submission envelope, e.g.
    #   { "id" => "...", "status" => "queued", "rows_total" => 3, ... }
    def submit(rows, target_framework)
      body = { target_framework: target_framework, rows: rows }
      post("/api/v1/submissions", body)
    end

    # Returns the parsed JSON report for one submission id.
    def fetch_report(id)
      get("/api/v1/submissions/#{URI.encode_uri_component(id)}")
    end

    # Polls fetch_report(id) until its "status" is "done" or "failed", or
    # `timeout` seconds have elapsed, backing off between polls (starting
    # at `interval` seconds, doubling up to `max_interval`). Raises
    # Interstandard::PollTimeout if the deadline passes first.
    def poll(id, timeout: 300, interval: 2, max_interval: 20)
      deadline = monotonic_now + timeout
      wait = interval

      loop do
        report = fetch_report(id)
        return report if %w[done failed].include?(report["status"])

        if monotonic_now >= deadline
          raise PollTimeout, "submission #{id} did not finish within #{timeout}s (last status: #{report["status"].inspect})"
        end

        sleep(wait)
        wait = [ wait * 2, max_interval ].min
      end
    end

    private

    def monotonic_now
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def get(path)
      request(Net::HTTP::Get.new(uri_for(path)))
    end

    def post(path, body)
      request = Net::HTTP::Post.new(uri_for(path))
      request["Content-Type"] = "application/json"
      request.body = JSON.generate(body)
      request(request)
    end

    def uri_for(path)
      URI.parse("#{@base_url}#{path}")
    end

    def request(req)
      raise Unauthorized, "INTERSTANDARD_API_KEY is not set" if @api_key.blank?

      req["Authorization"] = "Bearer #{@api_key}"
      uri = req.uri

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https",
        open_timeout: DEFAULT_OPEN_TIMEOUT, read_timeout: DEFAULT_READ_TIMEOUT) do |http|
        http.request(req)
      end

      handle(response)
    end

    def handle(response)
      case response.code.to_i
      when 200, 201, 202
        parse(response)
      when 401
        raise Unauthorized, error_message(response, default: "Interstandard rejected the API key (401)")
      when 429
        payload = parse(response) rescue {}
        raise RateLimited.new(
          error_message(response, default: "Interstandard rate-limited this request (429)"),
          retry_after: response["Retry-After"]&.to_i
        )
      else
        payload = parse(response) rescue {}
        code = payload.is_a?(Hash) ? payload.dig("error", "code") : nil
        raise RequestFailed.new(
          error_message(response, default: "Interstandard request failed (#{response.code})"),
          status: response.code.to_i,
          code: code
        )
      end
    end

    def parse(response)
      return {} if response.body.blank?
      JSON.parse(response.body)
    end

    def error_message(response, default:)
      payload = JSON.parse(response.body) rescue nil
      message = payload.is_a?(Hash) ? payload.dig("error", "message") : nil
      message.presence || default
    end
  end
end
