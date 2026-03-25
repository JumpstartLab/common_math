class ContentModule < ApplicationRecord
  belongs_to :grade
  has_many :topics, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_many :supplemental_resources, as: :resourceable, dependent: :destroy
  has_many :standard_taggings, as: :taggable
  has_many :standards, through: :standard_taggings

  validates :number, presence: true, uniqueness: { scope: :grade_id }
  validates :title, presence: true
  validates :position, presence: true
end
