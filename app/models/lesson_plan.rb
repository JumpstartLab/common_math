class LessonPlan < ApplicationRecord
  belongs_to :lesson
  has_many :expressions, as: :source, dependent: :destroy

  validates :content_html, presence: true
end
