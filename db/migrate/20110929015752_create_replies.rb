class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :postId
      t.text :reply
      t.string :repliedUser

      t.timestamps
    end
  end
end
