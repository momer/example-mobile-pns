class CreatePermittedApps < ActiveRecord::Migration
  def change
    create_table :permitted_apps do |t|
      t.text :authentication_token
      
      t.timestamps
    end
  end
end
