class ChangeColumnToUsers < ActiveRecord::Migration
  def change
    change_column :users, :authority, :string, null: false, default: 'student'
  end
end
