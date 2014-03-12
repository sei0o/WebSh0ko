class ChangeColumnToBooks < ActiveRecord::Migration
  def change
    change_column :books, :title, :string, null: false, unique:true
    
  end
end
