class RemoveColumnToRoles < ActiveRecord::Migration
  def change
    remove_column :roles, :user_create # 考えてみた >> 誰にでもできる
  end
end