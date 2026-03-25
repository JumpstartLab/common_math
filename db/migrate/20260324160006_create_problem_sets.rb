class CreateProblemSets < ActiveRecord::Migration[8.1]
  def change
    create_table :problem_sets do |t|
      t.references :lesson, null: false, foreign_key: true, index: { unique: true }
      t.text :content_html, null: false

      t.timestamps
    end
  end
end
