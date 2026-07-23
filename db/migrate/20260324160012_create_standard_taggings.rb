class CreateStandardTaggings < ActiveRecord::Migration[8.1]
  def change
    create_table :standard_taggings do |t|
      t.references :standard, null: false, foreign_key: true
      t.references :taggable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :standard_taggings, [ :standard_id, :taggable_type, :taggable_id ],
              unique: true, name: "idx_standard_taggings_uniqueness"
  end
end
