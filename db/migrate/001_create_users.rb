class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 100
      t.string :email, null: false
      t.string :password, null: true # For demo purposes, making password optional
      t.string :avatar_url
      t.boolean :is_active, default: true, null: false
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, :is_active
  end
end
