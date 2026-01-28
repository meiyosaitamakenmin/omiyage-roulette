class CreateSouvenirs < ActiveRecord::Migration[8.1]
  def change
    create_table :souvenirs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false, limit: 100
      t.integer :price, null: false
      t.integer :category, null: false, default: 0
      t.text :description
      t.string :image_url, limit: 2048

      t.timestamps null: false
    end

    add_index :souvenirs, [:user_id, :category]
    add_index :souvenirs, :price
  end
end
