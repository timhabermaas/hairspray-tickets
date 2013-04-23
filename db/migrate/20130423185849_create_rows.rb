class CreateRows < ActiveRecord::Migration
  def change
    create_table :rows do |t|
      t.integer :y, :null => false
      t.integer :number, :null => false

      t.timestamps
    end
  end
end
