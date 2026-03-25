class AddSourceFileToLessons < ActiveRecord::Migration[8.1]
  def change
    add_column :lessons, :source_file, :string
    add_column :lessons, :head_html, :text
  end
end
