class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      ## User data
      t.string :name,   null: false

      ## Admin data
      t.boolean :admin,      null: false, default: false
      t.boolean :staff,      null: false, default: false

      ##  Galaxy specific fields and github fields
      t.integer :karma,             null: false, default: 0
      t.string  :github_avatar_url, null: false, default: ''
      t.string  :github_html_url,   null: false, default: ''
      t.string  :github_id,         null: false
      t.string  :github_login,      null: false
      t.string  :github_company,    null: false, default: ''
      t.string  :github_type,       null: false
      t.string  :github_blog,       null: false, default: ''
      t.string  :github_html_url,   null: false
      t.string  :github_location,   null: false, default: ''
      t.string  :github_bio,        null: false, default: ''

      ## Github date times
      t.datetime :github_created_at, null: false
      t.datetime :github_updated_at, null: false


      ## Database authenticatable (no password as you can't login in with password)
      t.string :email, null: false, default: ''

      ## t.string :encrypted_password, null: false, default: ""

      ## Devise Recoverable
      # t.string   :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Devise Rememberable
      t.datetime :remember_created_at

      ## Devise Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.timestamps null: false
    end

    # add_index :users, :email, unique: true
    add_index :users, :github_id, unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
