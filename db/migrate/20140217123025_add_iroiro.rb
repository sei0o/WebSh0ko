class AddIroiro < ActiveRecord::Migration
  def change
    change_column :users, :authority, :integer, null: false, default: "1"
    rename_column :users, :authority, :role_id
  end
end
