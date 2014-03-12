class ChangeColumnForUsers < ActiveRecord::Migration
  def change
    add_column :users, :icon_type, :string
  end
end
