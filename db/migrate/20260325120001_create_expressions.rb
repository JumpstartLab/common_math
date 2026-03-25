class CreateExpressions < ActiveRecord::Migration[8.1]
  def change
    create_table :expressions do |t|
      t.references :source, polymorphic: true, null: false
      t.integer :position, null: false
      t.text :omml
      t.text :mathml
      t.text :aspose_html
      t.text :image_data
      t.string :image_content_type
      t.string :text_representation
      t.string :conversion_status, null: false, default: "pending"
      t.jsonb :conversion_notes, default: {}

      t.timestamps
    end

    add_index :expressions, [:source_type, :source_id, :position], unique: true,
              name: "idx_expressions_source_position"
    add_index :expressions, :conversion_status
  end
end
