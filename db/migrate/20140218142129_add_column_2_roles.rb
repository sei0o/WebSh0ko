class AddColumn2Roles < ActiveRecord::Migration
  def change
    # Rolesそのもの
    add_column :roles, :role_create, :boolean, null: false, default: false
    add_column :roles, :role_read, :boolean, null: false, default: false
    add_column :roles, :role_update, :boolean, null: false, default: false
    add_column :roles, :role_delete, :boolean, null: false, default: false
  end
end
