class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.string :username
      t.string :screenname
      t.integer :follower_count
      t.string :thumb

      t.timestamps null: false
    end
  end
end
