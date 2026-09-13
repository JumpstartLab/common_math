require "nokogiri"

module Engageny
  # Extracts CCSS codes from the "Focus Standards" markup EngageNY topic
  # overviews carry (a `ny-list-focusstandards` CSS class applied to the
  # paragraphs/list items Aspose emits for that Word list style, the same
  # convention as `ny-h1` for headings — see Engageny::Importer#extract_topic_title)
  # and turns them into StandardTagging rows.
  #
  # Focus Standards are listed once per Topic overview in the source
  # curriculum, not per Lesson, so the Topic is the canonical taggable and
  # every Lesson under it inherits the union of its Topic's standards.
  class FocusStandardTagger
    FOCUS_STANDARDS_CLASS = "ny-list-focusstandards"

    # Matches a full standard code, optionally with an embedded cluster
    # letter (e.g. "5.NBT.1" or "5.NBT.A.1"), or a bare cluster reference
    # with no leaf number (e.g. "5.NBT.A"). The longer, number-bearing form
    # is tried first so it wins over the shorter cluster-only alternative.
    CODE_PATTERN = %r{
      \d{1,2}\.[A-Z]{1,4}\.(?:[A-Z]\.)?\d+[a-z]?  # e.g. 5.NBT.1, 5.NBT.A.1, 5.NF.4a
      | \d{1,2}\.[A-Z]{1,4}\.[A-Z]\b                # cluster only, e.g. 5.NBT.A
    }x

    Report = Struct.new(:topic_taggings, :lesson_taggings, :unresolved, keyword_init: true) do
      def initialize(**kwargs)
        super(topic_taggings: 0, lesson_taggings: 0, unresolved: Hash.new(0), **kwargs)
      end

      def merge!(other)
        self.topic_taggings += other.topic_taggings
        self.lesson_taggings += other.lesson_taggings
        other.unresolved.each { |code, count| unresolved[code] += count }
        self
      end
    end

    # Extracts the raw CCSS codes present in the given HTML's focus-standards
    # markup. Returns [] for blank, nil, or malformed HTML, or HTML with no
    # focus-standards markup at all. Never raises.
    def self.extract_codes(html)
      return [] if html.blank?

      doc = Nokogiri::HTML::DocumentFragment.parse(html)
      nodes = doc.css(".#{FOCUS_STANDARDS_CLASS}")
      return [] if nodes.empty?

      text = nodes.map(&:text).join(" ")
      text = text.scrub("")
      text.scan(CODE_PATTERN).uniq
    rescue StandardError
      []
    end

    # Normalizes a raw extracted code to the dotted form Standard#code uses:
    # grade.domain.number[subletter], with any embedded cluster letter
    # stripped (our imported Standard rows never carry the cluster letter,
    # e.g. "5.NBT.1" not "5.NBT.A.1"). A bare cluster reference like
    # "5.NBT.A" has no leaf number to normalize to and is returned as-is —
    # it will not resolve to a Standard and is reported unresolved.
    def self.normalize(raw_code)
      parts = raw_code.split(".")
      return raw_code unless parts.last.match?(/\A\d+[a-z]?\z/)
      return raw_code unless parts.length == 4

      [ parts[0], parts[1], parts[3] ].join(".")
    end

    # Tags a single Topic (from its overview_html) and every Lesson beneath
    # it (with the same, unioned set of standards). Idempotent: existing
    # StandardTagging rows are left alone and not recreated.
    def self.tag_topic!(topic)
      report = Report.new
      codes = extract_codes(topic.overview_html)
      return report if codes.empty?

      standards = []
      codes.each do |raw|
        normalized = normalize(raw)
        standard = Standard.find_by(code: normalized)
        if standard
          standards << standard
        else
          report.unresolved[normalized] += 1
        end
      end
      standards.uniq!
      return report if standards.empty?

      report.topic_taggings += create_missing_taggings(topic, standards)

      topic.lessons.each do |lesson|
        report.lesson_taggings += create_missing_taggings(lesson, standards)
      end

      report
    end

    def self.create_missing_taggings(taggable, standards)
      existing_ids = StandardTagging.where(
        taggable_type: taggable.class.polymorphic_name,
        taggable_id: taggable.id
      ).pluck(:standard_id)

      to_create = standards.reject { |s| existing_ids.include?(s.id) }
      return 0 if to_create.empty?

      now = Time.current
      StandardTagging.insert_all(
        to_create.map do |standard|
          {
            standard_id: standard.id,
            taggable_type: taggable.class.polymorphic_name,
            taggable_id: taggable.id,
            created_at: now,
            updated_at: now
          }
        end
      )
      to_create.size
    end
    private_class_method :create_missing_taggings
  end
end
