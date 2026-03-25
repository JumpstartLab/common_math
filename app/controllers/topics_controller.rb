class TopicsController < ApplicationController
  def show
    @grade = Grade.find(params[:grade_id])
    @content_module = @grade.content_modules.find(params[:content_module_id])
    @topic = @content_module.topics.find(params[:id])
    @lessons = @topic.lessons.includes(:lesson_plan, :problem_set, :exit_ticket, :homework).order(:position)
  end
end
