class CreateFranchises < ActiveRecord::Migration[5.0]
  def change
    create_table :franchises do |t|
      t.string :name
      t.string :owner
      t.string :email
      t.integer :phone_number, limit: 8

      t.timestamps
    end
  end
end
