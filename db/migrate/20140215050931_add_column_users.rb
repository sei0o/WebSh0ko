class AddColumnUsers < ActiveRecord::Migration
  def change
    add_column :users, :icon, :binary, limit: 10.megabytes
  end
end
