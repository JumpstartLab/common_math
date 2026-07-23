class CreateProblems < ActiveRecord::Migration[8.1]
  def change
    create_table :problems do |t|
      t.references :source, polymorphic: true, null: false
      t.text :content_html, null: false
      t.text :answer
      t.string :answer_format
      t.integer :position, null: false

      t.timestamps
    end

    add_index :problems, [ :source_type, :source_id, :position ], unique: true
  end
end
