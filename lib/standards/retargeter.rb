module Standards
  # Submits every existing (CCSS) StandardTagging to Interstandard for one
  # target framework, then stores confirmed exact/grade_shifted results as
  # StateStandardTaggings. Used by lib/tasks/standards.rake's
  # standards:retarget[framework] task.
  #
  # Idempotent: re-running upserts by StateStandardTagging's unique key
  # (taggable, target_framework, state_code, standard) rather than deleting,
  # and marks rows absent from the latest report `stale_at` instead of
  # destroying them, so review_state/disputed history survives a transient
  # Interstandard hiccup.
  class Retargeter
    RELATIONSHIPS_TO_STORE = %w[exact grade_shifted].freeze

    Report = Struct.new(:target_framework, :stored, :no_confirmed_match, :invalid, :stale, keyword_init: true) do
      def initialize(**kwargs)
        super(stored: 0, no_confirmed_match: [], invalid: [], stale: 0, **kwargs)
      end
    end

    def initialize(client: Interstandard::Client.new)
      @client = client
    end

    def call(target_framework)
      report = Report.new(target_framework: target_framework)
      taggings = StandardTagging.includes(:standard, :taggable).to_a
      return report if taggings.empty?

      by_item_id = taggings.index_by { |tagging| item_id_for(tagging) }
      submission = @client.submit(taggings.map { |tagging| row_for(tagging) }, target_framework)
      payload = @client.poll(submission["id"])

      seen_keys = []

      Array(payload["rows"]).each do |row|
        tagging = by_item_id[row["item_id"]]
        next unless tagging

        case row["status"]
        when "matched"
          confirmed = confirmed_results(row)
          confirmed.each do |result|
            seen_keys << store_result!(tagging, target_framework, result)
            report.stored += 1
          end
          report.no_confirmed_match << row["item_id"] if confirmed.empty?
        when "no_confirmed_match"
          report.no_confirmed_match << row["item_id"]
        when "invalid"
          report.invalid << { item_id: row["item_id"], error: row["error"] }
        end
      end

      mark_stale!(target_framework, seen_keys, report)
      report
    end

    private

    def confirmed_results(row)
      Array(row["results"]).select do |result|
        RELATIONSHIPS_TO_STORE.include?(result["relationship"]) &&
          result["review_state"] == "confirmed" &&
          !result["disputed"]
      end
    end

    def row_for(tagging)
      { item_id: item_id_for(tagging), source_framework: Interstandard::SOURCE_FRAMEWORK, code: tagging.standard.code }
    end

    def item_id_for(tagging)
      "#{tagging.taggable_type}:#{tagging.taggable_id}:#{tagging.standard.code}"
    end

    def store_result!(tagging, target_framework, result)
      taggable = tagging.taggable

      record = StateStandardTagging.find_or_initialize_by(
        taggable: taggable,
        target_framework: target_framework,
        state_code: result["code"],
        standard: tagging.standard
      )
      record.assign_attributes(
        state_statement: result["statement"],
        relationship: result["relationship"],
        confidence: result["confidence"],
        review_state: result["review_state"],
        disputed: result["disputed"] || false,
        provenance: result.dig("provenance", "kind"),
        edge_provenance_ref: result.dig("provenance", "ref"),
        retired: false,
        retargeted_at: Time.current,
        stale_at: nil
      )
      record.save!

      [ taggable.class.polymorphic_name, taggable.id, target_framework, result["code"], tagging.standard_id ]
    end

    def mark_stale!(target_framework, seen_keys, report)
      seen = seen_keys.map { |key| key.join("|") }.to_set

      StateStandardTagging.for_framework(target_framework).where(stale_at: nil).find_each do |existing|
        key = [ existing.taggable_type, existing.taggable_id, existing.target_framework, existing.state_code, existing.standard_id ].join("|")
        next if seen.include?(key)

        existing.mark_stale!
        report.stale += 1
      end
    end
  end
end
