class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.text :platform
      t.text :token

      t.integer :user_id
      
      t.timestamps
    end
  end
end
