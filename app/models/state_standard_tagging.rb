# A Lesson or Topic retargeted from a CCSS Standard onto one state
# framework's code, via the Interstandard translator. One row per
# (taggable, target_framework, state_code, standard_id) — the same taggable
# can carry several state codes for the same framework (a composed match)
# and codes across several frameworks.
#
# Re-running standards:retarget upserts by that key rather than deleting:
# a code missing from the latest report is marked `stale_at` instead, so a
# transient Interstandard hiccup can't silently erase confirmed history.
class StateStandardTagging < ApplicationRecord
  belongs_to :taggable, polymorphic: true
  belongs_to :standard

  validates :target_framework, presence: true
  validates :state_code, presence: true
  validates :relationship, presence: true
  validates :review_state, presence: true
  validates :retargeted_at, presence: true
  validates :standard_id, uniqueness: {
    scope: [ :taggable_type, :taggable_id, :target_framework, :state_code ]
  }

  scope :for_framework, ->(framework) { where(target_framework: framework) }
  scope :fresh, -> { where(stale_at: nil, retired: false) }
  scope :stale, -> { where.not(stale_at: nil) }

  # Marks this row stale as of now, rather than destroying it, so it keeps
  # its history and can flip back to fresh on a later confirmed re-run.
  def mark_stale!
    update!(stale_at: Time.current) if stale_at.nil?
  end

  # Clears a previously-set stale mark when a fresh retarget confirms the
  # row again.
  def unmark_stale!
    update!(stale_at: nil) unless stale_at.nil?
  end
end
