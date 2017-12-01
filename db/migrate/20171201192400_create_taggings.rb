class CreateTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.belongs_to :spin, index: true
      t.belongs_to :tag,  index: true

      t.timestamps
    end
    add_foreign_key :taggings, :tag
  end
end
