class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :userName
      t.string :unityId
      t.string :password
      t.string :emailAddress
      t.string :role

      t.timestamps
    end
  end
end
