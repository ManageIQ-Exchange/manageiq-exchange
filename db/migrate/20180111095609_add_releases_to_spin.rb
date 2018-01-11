class AddReleasesToSpin < ActiveRecord::Migration[5.1]
  def change
    add_column :spins, :releases, :jsonb, default: []
  end
end
