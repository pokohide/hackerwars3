class AddWinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :win, :integer, default: 0
    add_column :users, :lose, :integer, default: 0
  end
end
