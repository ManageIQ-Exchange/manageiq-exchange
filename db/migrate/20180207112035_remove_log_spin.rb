class RemoveLogSpin < ActiveRecord::Migration[5.1]
  def change
    remove_column :spins, :log
  end
end
