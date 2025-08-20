class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false, limit: 200
      t.text :description
      t.string :status, null: false, default: 'active'
      t.date :start_date
      t.date :end_date
      
      t.timestamps
    end
    
    add_index :projects, :status
    add_index :projects, :name
  end
end
