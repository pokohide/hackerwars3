class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.string :name
      t.string :screen_name
      t.integer :tweets_count
      t.integer :followers_count
      t.string :profile_image_url
      t.string :category

      t.timestamps null: false
    end
  end
end
