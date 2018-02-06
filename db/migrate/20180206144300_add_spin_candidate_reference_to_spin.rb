class AddSpinCandidateReferenceToSpin < ActiveRecord::Migration[5.1]
  def change
    add_reference :spins, :spin_candidate, foreign_key: true
  end
end
