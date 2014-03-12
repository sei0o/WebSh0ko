class ChangeForBooks < ActiveRecord::Migration
  def change
    change_column :books, :page, :integer, null: true
  end
end
