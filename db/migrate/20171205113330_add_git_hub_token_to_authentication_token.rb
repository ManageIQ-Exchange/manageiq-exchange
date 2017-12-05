class AddGitHubTokenToAuthenticationToken < ActiveRecord::Migration[5.1]
  def change
    add_column :authentication_tokens, :github_token, :string
  end
end
