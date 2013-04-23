class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :number, :null => false
      t.integer :x, :null => false
      t.integer :row_id, :null => false

      t.timestamps
    end
  end
end
