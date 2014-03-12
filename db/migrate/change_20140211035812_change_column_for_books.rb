class ChangeColumnForBooks < ActiveRecord::Migration
  def change
    change_column :books, :publish, :date, null: true
  end
end
