class AddLogToSpin < ActiveRecord::Migration[5.1]
  def change
    add_column :spins, :log, :text
  end
end
