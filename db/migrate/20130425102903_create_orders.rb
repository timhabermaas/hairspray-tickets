class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name, :null => false
      t.datetime :paid_at
      t.integer :reduced_count, :null => false, :default => 0
      t.integer :gig_id, :null => false

      t.timestamps
    end
  end
end
