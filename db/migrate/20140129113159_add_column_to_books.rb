class AddColumnToBooks < ActiveRecord::Migration
  def change
    add_column :books, :writer, :string
  end
end
