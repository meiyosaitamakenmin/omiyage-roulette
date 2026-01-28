class SorceryCore < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 50
      t.string :email, null: false, limit: 255
      t.string :crypted_password, limit: 255
      t.string :salt, limit: 255
      t.string :avatar_url, limit: 2048

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
