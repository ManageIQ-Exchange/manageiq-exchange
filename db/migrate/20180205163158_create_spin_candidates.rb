class CreateSpinCandidates < ActiveRecord::Migration[5.1]
  def change
    create_table :spin_candidates do |t|
      t.text :full_name,  nil: false
      t.text :validation_log
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
