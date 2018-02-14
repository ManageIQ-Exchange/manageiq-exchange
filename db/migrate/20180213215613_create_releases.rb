class CreateReleases < ActiveRecord::Migration[5.1]
  def change
    create_table :releases do |t|

      t.boolean    :draft,          nil: false, default: false
      t.string     :tag,            nil: false
      t.text       :name,           nil: true,  default: ''
      t.boolean    :prerelease,     nil: false, default: false
      t.string     :zipball_url,    nil: false
      t.datetime   :created_at,     nil: false
      t.datetime   :published_at,   nil: false
      t.jsonb      :author,         nil: false, default: {}
      t.references :spin,    foreign_key: true
      t.timestamps
    end
    add_index :releases, :tag
    remove_column :spins, :releases
  end
end
