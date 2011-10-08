class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :postString
      t.integer :votesReceived
      t.string :postOwner
      t.string :anonymous
      t.string :status
      t.string :spam
      t.integer :parentPostID
      t.integer :weight
      t.integer:user_id



      t.timestamps
    end
  end
end
