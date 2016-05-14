class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.string :username
      t.string :screenname
      t.integer :tweets_count
      t.integer :follower_count
      t.string :thumbnail
      t.string :category

      t.timestamps null: false
    end
  end
end
