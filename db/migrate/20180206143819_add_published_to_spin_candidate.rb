class AddPublishedToSpinCandidate < ActiveRecord::Migration[5.1]
  def change
    add_column :spin_candidates, :published, :boolean
    add_index :spin_candidates, :published
    add_column :spin_candidates, :validated, :boolean
    add_column :spin_candidates, :last_validation, :datetime
  end
end
