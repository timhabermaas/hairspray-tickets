class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :seat_id, :null => false
      t.integer :order_id, :null => false

      t.timestamps
    end
  end
end
