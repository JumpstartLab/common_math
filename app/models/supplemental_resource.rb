class SupplementalResource < ApplicationRecord
  belongs_to :resourceable, polymorphic: true

  validates :resource_type, presence: true
  validates :source, presence: true
  validates :title, presence: true

  RESOURCE_TYPES = %w[
    video
    lesson_pdf
    google_slides
    homework_solutions
    exit_ticket_solutions
    topic_quiz
    parent_newsletter
    pacing_guide
    eureka_essentials
    application_problems
    fluency_games
    vocabulary
    number_talks
    geogebra
    online_practice
    mid_module_review
    end_module_review
    downloadable_resources
    smartboard
    promethean_flipchart
    go_formative
    other
  ].freeze

  SOURCES = %w[embarc].freeze

  validates :resource_type, inclusion: { in: RESOURCE_TYPES }
  validates :source, inclusion: { in: SOURCES }

  scope :by_type, ->(type) { where(resource_type: type) }
  scope :from_source, ->(source) { where(source: source) }
  scope :with_content, -> { where.not(content_html: nil) }
  scope :external_only, -> { where(content_html: nil).where.not(url: nil) }

  def external?
    url.present? && content_html.blank?
  end

  def inline?
    content_html.present?
  end
end
