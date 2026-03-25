class Grade < ApplicationRecord
  has_many :content_modules, dependent: :destroy
  has_many :supplemental_resources, as: :resourceable, dependent: :destroy

  validates :number, presence: true, uniqueness: true
  validates :title, presence: true
end
