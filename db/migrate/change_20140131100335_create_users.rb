class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :authority, null: false
      t.string :name, null: false
      t.string :account, null: false, unique: true
      t.string :password_digest, null: false
      t.text :bio
      t.integer :class_id
      
      t.timestamps
    end
  end
end
