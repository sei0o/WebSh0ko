class CreateLends < ActiveRecord::Migration
  def change
    create_table :lends do |t|
      t.integer :user_id
      t.integer :book_id, null: false
      t.boolean :lending, null: false

      t.timestamps
    end
  end
end
