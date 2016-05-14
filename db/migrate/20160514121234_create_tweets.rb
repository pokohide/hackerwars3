class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id
      t.string :name
      t.string :screen_name
      t.string :full_text

      t.timestamps null: false
    end
  end
end
