class Standard < ApplicationRecord
  has_many :standard_taggings, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :description, presence: true
  validates :domain, presence: true
  validates :grade_level, presence: true
end
