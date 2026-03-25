class Homework < ApplicationRecord
  belongs_to :lesson
  has_many :problems, as: :source, dependent: :destroy
  has_many :expressions, as: :source, dependent: :destroy

  validates :content_html, presence: true
end
