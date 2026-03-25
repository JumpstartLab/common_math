class CreateExitTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :exit_tickets do |t|
      t.references :lesson, null: false, foreign_key: true, index: { unique: true }
      t.text :content_html, null: false

      t.timestamps
    end
  end
end
