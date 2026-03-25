class CreateLessonPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :lesson_plans do |t|
      t.references :lesson, null: false, foreign_key: true, index: { unique: true }
      t.text :content_html, null: false
      t.integer :suggested_duration_minutes

      t.timestamps
    end
  end
end
