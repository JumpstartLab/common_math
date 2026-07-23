class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.references :topic, null: false, foreign_key: true
      t.integer :number, null: false
      t.text :objective
      t.integer :position, null: false

      t.timestamps
    end

    add_index :lessons, [ :topic_id, :number ], unique: true
    add_index :lessons, [ :topic_id, :position ]
  end
end
