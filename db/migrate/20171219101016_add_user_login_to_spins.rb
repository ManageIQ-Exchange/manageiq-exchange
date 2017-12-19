class AddUserLoginToSpins < ActiveRecord::Migration[5.1]
  def up
    add_column :spins, :user_login, :string

    Spin.all.each do |spin|
      spin.update(user_login: spin.user.github_login)
    end
  end

  def down
    remove_column :spins, :user_login
  end

end
