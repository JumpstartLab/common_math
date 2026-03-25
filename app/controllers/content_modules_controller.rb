class ContentModulesController < ApplicationController
  def show
    @grade = Grade.find(params[:grade_id])
    @content_module = @grade.content_modules.find(params[:id])
    @topics = @content_module.topics.order(:position).includes(:lessons)
  end
end
