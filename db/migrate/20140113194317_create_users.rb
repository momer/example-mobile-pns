class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :email
      t.text :sex

      t.decimal :lat
      t.decimal :lng
      
      t.timestamps
    end
  end
end
