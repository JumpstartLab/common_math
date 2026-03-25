class CreateGrades < ActiveRecord::Migration[8.1]
  def change
    create_table :grades do |t|
      t.integer :number, null: false
      t.string :title, null: false

      t.timestamps
    end

    add_index :grades, :number, unique: true
  end
end
