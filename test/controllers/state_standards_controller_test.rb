require "test_helper"

class StateStandardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    grade = Grade.create!(number: 5, title: "Grade 5")
    content_module = grade.content_modules.create!(number: 1, title: "Module 1", position: 1)
    @topic = content_module.topics.create!(letter: "A", title: "Topic A", position: 1)
    @lesson = @topic.lessons.create!(number: 1, position: 1)
    @standard = Standard.create!(code: "5.NF.1", domain: "d", description: "d", grade_level: 5)

    @fresh = StateStandardTagging.create!(
      taggable: @lesson, standard: @standard, target_framework: "co-math-2020",
      state_code: "CO.5.NF.1", state_statement: "Adds fractions", relationship: "exact",
      review_state: "confirmed", retargeted_at: Time.current
    )
  end

  test "index lists frameworks with fresh taggings and their counts" do
    get state_standards_path
    assert_response :success
    assert_match "co-math-2020", response.body
  end

  test "index omits a framework whose only taggings are stale" do
    @fresh.mark_stale!

    get state_standards_path
    assert_response :success
    assert_no_match "co-math-2020", response.body
  end

  test "show lists the framework's codes with statements" do
    get state_standard_path("co-math-2020")
    assert_response :success
    assert_match "CO.5.NF.1", response.body
    assert_match "Adds fractions", response.body
  end

  test "show 404s for a framework with no fresh taggings" do
    get state_standard_path("nonexistent-framework")
    assert_response :not_found
  end

  test "code page lists the taggable tagged to that code, linking to it" do
    get state_standard_code_path("co-math-2020", "CO.5.NF.1")
    assert_response :success
    assert_match @lesson.label, response.body
  end

  test "code page 404s for a code with no fresh taggings" do
    get state_standard_code_path("co-math-2020", "CO.5.NF.999")
    assert_response :not_found
  end

  test "code page excludes retired taggings" do
    @fresh.update!(retired: true)

    get state_standard_code_path("co-math-2020", "CO.5.NF.1")
    assert_response :not_found
  end

  test "lesson show links to the state code page" do
    get grade_content_module_topic_lesson_path(@lesson.topic.content_module.grade, @lesson.topic.content_module, @lesson.topic, @lesson)
    assert_response :success
    assert_match state_standard_code_path("co-math-2020", "CO.5.NF.1"), response.body
  end
end
