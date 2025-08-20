class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :issue, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.boolean :is_internal, default: false, null: false
      
      t.timestamps
    end
    
    add_index :comments, [:issue_id, :created_at]
    add_index :comments, :is_internal
  end
end
