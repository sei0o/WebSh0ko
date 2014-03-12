class ChangeColumnForLends < ActiveRecord::Migration
  def change
    change_column :lends, :limit, :date
  end
end
