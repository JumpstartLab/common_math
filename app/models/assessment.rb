class Assessment < ApplicationRecord
  belongs_to :content_module
  has_many :problems, as: :source, dependent: :destroy
  has_many :standard_taggings, as: :taggable
  has_many :standards, through: :standard_taggings

  validates :assessment_type, presence: true, uniqueness: { scope: :content_module_id }
  validates :content_html, presence: true
end
