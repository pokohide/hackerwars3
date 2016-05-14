class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :card_id
      t.string :trend_word
      t.string :result
      t.time :start_time
      t.time :end_time
      t.boolean :finished, default: false

      t.timestamps null: false
    end
  end
end
