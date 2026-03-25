class CreateModules < ActiveRecord::Migration[8.1]
  def change
    create_table :content_modules do |t|
      t.references :grade, null: false, foreign_key: true
      t.integer :number, null: false
      t.string :title, null: false
      t.text :overview_html
      t.integer :position, null: false

      t.timestamps
    end

    add_index :content_modules, [:grade_id, :number], unique: true
    add_index :content_modules, [:grade_id, :position]
  end
end
