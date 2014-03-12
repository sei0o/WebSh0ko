class AddColumnToRoles < ActiveRecord::Migration
  def change
    # GRANT copy
    add_column :roles, :grant, :boolean, null: false, default: false
    # Book ( CRUD LRe )
    add_column :roles, :book_create, :boolean, null: false, default: false
    add_column :roles, :book_read, :boolean, null: false, default: false
    add_column :roles, :book_update, :boolean, null: false, default: false
    add_column :roles, :book_delete, :boolean, null: false, default: false
    
    #   分ける必要あるかな？
    add_column :roles, :book_lend, :boolean, null: false, default: false
    add_column :roles, :book_return, :boolean, null: false, default: false
    # User ( CRUD (F) )
    add_column :roles, :user_create, :boolean, null: false, default: false
    add_column :roles, :user_read, :boolean, null: false, default: false
    add_column :roles, :secret_user_read, :boolean, null: false, default: false
    add_column :roles, :user_update, :boolean, null: false, default: false
    add_column :roles, :user_delete, :boolean, null: false, default: false
    
    add_column :roles, :user_follow, :boolean, null: false, default: false
    
    # Shelf
    # category
    # school
    # class
    # level
  end
end
