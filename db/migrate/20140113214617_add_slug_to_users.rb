class AddSlugToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text :slug
    end
    
    add_index :users, :slug, unique: true
  end
end
