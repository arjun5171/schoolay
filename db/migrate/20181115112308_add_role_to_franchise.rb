class AddRoleToFranchise < ActiveRecord::Migration[5.0]
  def change
    add_column :franchises, :role, :integer
  end
end
