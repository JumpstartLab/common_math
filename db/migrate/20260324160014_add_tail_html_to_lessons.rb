class AddTailHtmlToLessons < ActiveRecord::Migration[8.1]
  def change
    add_column :lessons, :tail_html, :text
  end
end
