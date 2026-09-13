require "test_helper"

class StateStandardTaggingTest < ActiveSupport::TestCase
  setup do
    @grade = Grade.create!(number: 5, title: "Grade 5")
    @content_module = @grade.content_modules.create!(number: 1, title: "Module 1", position: 1)
    @topic = @content_module.topics.create!(letter: "A", title: "Topic A", position: 1)
    @lesson = @topic.lessons.create!(number: 1, position: 1)
    @standard = Standard.create!(code: "5.NF.1", domain: "Number and Operations—Fractions", description: "d", grade_level: 5)
  end

  def base_attrs
    {
      taggable: @lesson,
      standard: @standard,
      target_framework: "co-math-2020",
      state_code: "5.NF.1",
      relationship: "exact",
      review_state: "confirmed",
      retargeted_at: Time.current
    }
  end

  test "valid with required attributes" do
    tagging = StateStandardTagging.new(base_attrs)
    assert tagging.valid?
  end

  test "unique on taggable + target_framework + state_code + standard" do
    StateStandardTagging.create!(base_attrs)
    duplicate = StateStandardTagging.new(base_attrs)

    assert_not duplicate.valid?
    assert_raises(ActiveRecord::RecordInvalid) { duplicate.save! }
  end

  test "same state_code for a different standard on the same taggable is allowed (composed match)" do
    StateStandardTagging.create!(base_attrs)
    other_standard = Standard.create!(code: "5.NF.2", domain: "d", description: "d", grade_level: 5)

    other = StateStandardTagging.new(base_attrs.merge(standard: other_standard))
    assert other.valid?
  end

  test "fresh scope excludes stale and retired rows" do
    fresh = StateStandardTagging.create!(base_attrs)
    stale = StateStandardTagging.create!(base_attrs.merge(state_code: "5.NF.2", stale_at: Time.current))
    retired = StateStandardTagging.create!(base_attrs.merge(state_code: "5.NF.3", retired: true))

    assert_includes StateStandardTagging.fresh, fresh
    assert_not_includes StateStandardTagging.fresh, stale
    assert_not_includes StateStandardTagging.fresh, retired
  end

  test "mark_stale! sets stale_at once and unmark_stale! clears it" do
    tagging = StateStandardTagging.create!(base_attrs)

    tagging.mark_stale!
    assert tagging.stale_at.present?

    stale_at = tagging.stale_at
    tagging.mark_stale!
    assert_equal stale_at, tagging.reload.stale_at

    tagging.unmark_stale!
    assert_nil tagging.reload.stale_at
  end

  test "for_framework scopes by target_framework" do
    StateStandardTagging.create!(base_attrs)
    other = StateStandardTagging.create!(base_attrs.merge(target_framework: "tx-teks-math", state_code: "111.7.b.3.G"))

    assert_includes StateStandardTagging.for_framework("co-math-2020"), StateStandardTagging.first
    assert_not_includes StateStandardTagging.for_framework("co-math-2020"), other
  end
end
