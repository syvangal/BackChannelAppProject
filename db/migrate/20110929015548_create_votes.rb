class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :postid
      t.string :usersVoted
      t.integer :numberOfVotes

      t.references :user
      t.references :post
      t.timestamps
    end
  end
end
