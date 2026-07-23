class CreateTopics < ActiveRecord::Migration[8.1]
  def change
    create_table :topics do |t|
      t.references :content_module, null: false, foreign_key: true
      t.string :letter, null: false
      t.string :title, null: false
      t.text :overview_html
      t.integer :position, null: false

      t.timestamps
    end

    add_index :topics, [ :content_module_id, :letter ], unique: true
    add_index :topics, [ :content_module_id, :position ]
  end
end
