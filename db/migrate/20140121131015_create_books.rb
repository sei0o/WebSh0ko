class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :photo
      t.string :title, null: false
      t.date :publish, null: false
      t.integer :page, null: false
      # t.string :lending
      t.integer :shelf_id
      t.string :category_id
      t.integer :rarity

      t.timestamps
    end
  end
end
