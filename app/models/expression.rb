class Expression < ApplicationRecord
  belongs_to :source, polymorphic: true

  validates :position, presence: true
  validates :conversion_status, presence: true,
            inclusion: { in: %w[pending converted fix_applied unconverted] }

  scope :converted, -> { where(conversion_status: %w[converted fix_applied]) }
  scope :needs_review, -> { where(conversion_status: %w[fix_applied unconverted]) }
end
