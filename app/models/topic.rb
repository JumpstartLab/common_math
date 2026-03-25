class Topic < ApplicationRecord
  belongs_to :content_module
  has_many :lessons, dependent: :destroy
  has_many :supplemental_resources, as: :resourceable, dependent: :destroy
  has_many :standard_taggings, as: :taggable
  has_many :standards, through: :standard_taggings

  validates :letter, presence: true, uniqueness: { scope: :content_module_id }
  validates :title, presence: true
  validates :position, presence: true
end
