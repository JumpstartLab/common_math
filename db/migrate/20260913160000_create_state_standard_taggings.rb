class CreateStateStandardTaggings < ActiveRecord::Migration[8.1]
  def change
    create_table :state_standard_taggings do |t|
      t.bigint :taggable_id, null: false
      t.string :taggable_type, null: false
      t.bigint :standard_id, null: false
      t.string :target_framework, null: false
      t.string :state_code, null: false
      t.text :state_statement
      t.string :relationship, null: false
      t.float :confidence
      t.string :review_state, null: false
      t.boolean :disputed, null: false, default: false
      t.string :provenance
      t.string :edge_provenance_ref
      t.boolean :retired, null: false, default: false
      t.datetime :retargeted_at, null: false
      t.datetime :stale_at

      t.timestamps
    end

    add_index :state_standard_taggings,
      [ :taggable_type, :taggable_id, :target_framework, :state_code, :standard_id ],
      unique: true,
      name: "idx_state_standard_taggings_uniqueness"
    add_index :state_standard_taggings, [ :taggable_type, :taggable_id ], name: "index_state_standard_taggings_on_taggable"
    add_index :state_standard_taggings, :standard_id
    add_index :state_standard_taggings, [ :target_framework, :state_code ]
    add_index :state_standard_taggings, :stale_at

    add_foreign_key :state_standard_taggings, :standards
  end
end
