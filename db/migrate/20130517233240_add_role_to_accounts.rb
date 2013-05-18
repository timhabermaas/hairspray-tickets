class AddRoleToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :role, :string, :null => false, :default => "user"
  end
end
