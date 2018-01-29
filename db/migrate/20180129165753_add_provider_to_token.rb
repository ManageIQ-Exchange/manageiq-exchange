class AddProviderToToken < ActiveRecord::Migration[5.1]
  def change
    add_column :authentication_tokens, :provider, :string
  end
end
