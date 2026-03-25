class ExitTicket < ApplicationRecord
  belongs_to :lesson
  has_many :problems, as: :source, dependent: :destroy

  validates :content_html, presence: true
end
