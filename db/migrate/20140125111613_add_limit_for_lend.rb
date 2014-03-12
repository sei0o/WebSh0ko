class AddLimitForLend < ActiveRecord::Migration
  def change
    add_column :lends, :limit, :datetime
  end
end
