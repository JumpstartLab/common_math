# Browse CCSS-to-state retargeting results (see lib/standards/retargeter.rb):
# a list of target frameworks, each framework's codes, and the lessons/
# topics tagged to a given code. Only non-stale, non-retired taggings are
# shown — a demoted or superseded state code drops off the browse pages the
# next time standards:retarget runs, without losing its history.
class StateStandardsController < ApplicationController
  def index
    frameworks = StateStandardTagging.fresh.distinct.order(:target_framework).pluck(:target_framework)

    @framework_stats = frameworks.map do |framework|
      scope = StateStandardTagging.fresh.for_framework(framework)
      {
        framework: framework,
        code_count: scope.distinct.count(:state_code),
        tagging_count: scope.count
      }
    end
  end

  def show
    @framework = params[:framework]
    scope = StateStandardTagging.fresh.for_framework(@framework)
    raise ActiveRecord::RecordNotFound if scope.none?

    @codes = scope.group(:state_code)
      .order(:state_code)
      .pluck(:state_code, Arel.sql("MAX(state_statement)"), Arel.sql("COUNT(*)"))
      .map { |code, statement, count| { code: code, statement: statement, count: count } }
  end

  def code
    @framework = params[:framework]
    @code = params[:code]
    @taggings = StateStandardTagging.fresh
      .for_framework(@framework)
      .where(state_code: @code)
      .includes(:taggable)
      .order(:relationship)
      .to_a
    raise ActiveRecord::RecordNotFound if @taggings.empty?
  end
end
