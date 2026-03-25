class LessonPlan < ApplicationRecord
  belongs_to :lesson

  validates :content_html, presence: true
end
