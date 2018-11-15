class AddUserToFranchise < ActiveRecord::Migration[5.0]
  def change
    add_reference :franchises, :user, foreign_key: true
  end
end
