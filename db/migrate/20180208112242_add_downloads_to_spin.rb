class AddDownloadsToSpin < ActiveRecord::Migration[5.1]
  def change
    add_column :spins, :downloads_count, :integer, default: 0
  end
end
