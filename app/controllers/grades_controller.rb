class GradesController < ApplicationController
  def index
    @grades = Grade.order(:number).includes(:content_modules)
  end

  def show
    @grade = Grade.find(params[:id])
    @content_modules = @grade.content_modules.includes(topics: :lessons).order(:position)
  end
end
