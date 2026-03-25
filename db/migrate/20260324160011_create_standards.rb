class CreateStandards < ActiveRecord::Migration[8.1]
  def change
    create_table :standards do |t|
      t.string :code, null: false
      t.text :description, null: false
      t.string :domain, null: false
      t.string :cluster
      t.integer :grade_level, null: false

      t.timestamps
    end

    add_index :standards, :code, unique: true
    add_index :standards, :grade_level
  end
end
