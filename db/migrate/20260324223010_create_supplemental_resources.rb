class CreateSupplementalResources < ActiveRecord::Migration[8.1]
  def change
    create_table :supplemental_resources do |t|
      t.references :resourceable, polymorphic: true, null: false
      t.string :resource_type, null: false
      t.string :source, null: false
      t.string :title, null: false
      t.string :url
      t.text :content_html
      t.string :source_page_url
      t.integer :position

      t.timestamps
    end

    add_index :supplemental_resources,
              [ :resourceable_type, :resourceable_id, :resource_type ],
              name: "idx_supplemental_resources_lookup"
    add_index :supplemental_resources, :resource_type
    add_index :supplemental_resources, :source
  end
end
