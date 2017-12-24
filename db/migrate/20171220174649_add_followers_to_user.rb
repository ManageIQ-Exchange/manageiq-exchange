class AddFollowersToUser < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :followers,    :integer, default: 0
    add_column :users, :public_repos, :integer, default: 0
  end

  def down
    remove_column :users, :followers
    remove_column :users, :public_repos
  end
end
