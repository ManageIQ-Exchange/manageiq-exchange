class CreateSpins < ActiveRecord::Migration[5.1]
  def change
    create_table :spins do |t|
      t.boolean :published,         nil: false, default: false
      t.string :name,               nil: false
      t.text :full_name,            nil: true,  default: ''
      t.text :description,          nil: false, default: ''
      t.string :clone_url,          nil: false
      t.string :html_url,           nil: false
      t.string :issues_url,         nil: true
      t.integer :forks_count,       nil: false, default: 0
      t.integer :stargazers_count,  nil: false, default: 0
      t.integer :watchers_count,    nil: false, default: 0
      t.integer :open_issues_count, nil: false, default: 0
      t.integer :size,              nil: false, default: 0
      t.string :gh_id,              nil: false
      t.datetime :gh_created_at
      t.datetime :gh_pushed_at
      t.datetime :gh_updated_at
      t.boolean :gh_archived,       nil: false, default: false
      t.string :default_branch,     nil: false, default: 'master'
      t.text :readme,               nil: false
      t.string :license_key,        nil: true
      t.string :license_name,       nil: true
      t.string :license_html_url,   nil: true
      t.string :version,            nil: false, default: '0.0.0'
      t.jsonb :metadata,            nil: false
      t.text :metadata_raw,         nil: false
      t.integer :min_miq_version,   nil: false, default: 0
      t.datetime :first_import,     nil: false
      t.float :score,               nil: false, default: 0
      t.references :user,           foreign_key: true
      t.text :company,              nil: true
      # Branches
      # Tags
      # Categories
      # Versions (version, branch)

      t.timestamps
    end
    add_index :spins, :published
  end
end
