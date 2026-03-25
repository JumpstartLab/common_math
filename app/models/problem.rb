class Problem < ApplicationRecord
  belongs_to :source, polymorphic: true

  validates :content_html, presence: true
  validates :position, presence: true
end
