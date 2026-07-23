class CreateAssessments < ActiveRecord::Migration[8.1]
  def change
    create_table :assessments do |t|
      t.references :content_module, null: false, foreign_key: true
      t.string :assessment_type, null: false
      t.text :content_html, null: false
      t.text :rubric_html
      t.text :answer_key_html

      t.timestamps
    end

    add_index :assessments, [ :content_module_id, :assessment_type ], unique: true
  end
end
