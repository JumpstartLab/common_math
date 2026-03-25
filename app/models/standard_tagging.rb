class StandardTagging < ApplicationRecord
  belongs_to :standard
  belongs_to :taggable, polymorphic: true
end
