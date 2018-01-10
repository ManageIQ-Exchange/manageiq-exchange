class AddVisibleBooleanToSpin < ActiveRecord::Migration[5.1]
  def change
    add_column :spins, :visible, :boolean, default: false
  end
end
