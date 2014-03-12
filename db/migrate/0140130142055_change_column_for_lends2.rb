class ChangeColumnForLends2 < ActiveRecord::Migration
  def change
    rename_column :lends, :lend_limit, :limit
  end
end