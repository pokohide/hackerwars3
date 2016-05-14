class AddEventIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :event_id, :integer

    remove_column :events, :card_id, :integer
  end
end
