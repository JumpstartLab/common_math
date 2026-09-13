module Standards
  # Fraction of a grade's lessons carrying at least one confirmed, non-stale,
  # non-retired state code for a given target framework. The success
  # criterion for Unit 10 is this at grade 5; standards:coverage also
  # accepts other grades (or "all").
  class Coverage
    Result = Struct.new(:framework, :grade_number, :total, :with_confirmed, keyword_init: true) do
      def fraction
        total.zero? ? 0.0 : with_confirmed.to_f / total
      end

      def percent
        (fraction * 100).round(1)
      end
    end

    def self.call(framework:, grade_number: nil)
      lessons = Lesson.joins(topic: { content_module: :grade })
      lessons = lessons.where(grades: { number: grade_number }) if grade_number

      total = lessons.count
      confirmed_ids = StateStandardTagging.fresh
        .for_framework(framework)
        .where(taggable_type: "Lesson", taggable_id: lessons.select(:id))
        .distinct
        .pluck(:taggable_id)

      Result.new(framework: framework, grade_number: grade_number, total: total, with_confirmed: confirmed_ids.size)
    end
  end
end
