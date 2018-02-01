class ModifyUserParameters < ActiveRecord::Migration[5.1]
  def change
    change_column_null    :users, :name,              true
    change_column_null    :users, :github_avatar_url, true
    change_column_default :users, :github_avatar_url, from: '', to: nil
    change_column_null    :users, :github_html_url,   true
    change_column_default :users, :github_html_url,   from: '', to: nil
    change_column_null    :users, :github_id,         true
    change_column_null    :users, :github_login,      true
    change_column_null    :users, :github_company,    true
    change_column_default :users, :github_company,    from: '', to: nil
    change_column_null    :users, :github_type,       true
    change_column_null    :users, :github_blog,       true
    change_column_default :users, :github_blog,       from: '', to: nil
    change_column_null    :users, :github_html_url,   true
    change_column_null    :users, :github_location,   true
    change_column_default :users, :github_location,   from: '', to: nil
    change_column_null    :users, :github_bio,        true
    change_column_default :users, :github_bio,        from: '', to: nil
    change_column_null    :users, :github_created_at, true
    change_column_null    :users, :github_updated_at, true
    change_column_null    :users, :email,             true
    change_column_default :users, :email,             from: '', to: nil

  end
end
