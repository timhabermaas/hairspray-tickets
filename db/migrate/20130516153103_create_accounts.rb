class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :login, :null => false
      t.string :email, :null => false
      t.string :password_digest, :null => false

      t.timestamps
    end
  end
end
