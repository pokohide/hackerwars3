class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :score, :integer
  end
end
