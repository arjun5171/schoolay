class AddAddressToFranchise < ActiveRecord::Migration[5.0]
  def change
    add_column :franchises, :address, :string
  end
end
