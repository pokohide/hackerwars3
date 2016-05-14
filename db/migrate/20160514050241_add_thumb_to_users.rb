class AddThumbToUsers < ActiveRecord::Migration
  def change
    add_column :users, :thumbnail, :string
  end
end
