class CreateIssues < ActiveRecord::Migration[7.1]
  def change
    create_table :issues do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title, null: false, limit: 500
      t.text :description
      t.string :status, null: false, default: 'active'
      t.string :priority, null: false, default: 'medium'
      t.references :assigned_to, null: true, foreign_key: { to_table: :users }
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.date :due_date
      
      t.timestamps
    end
    
    add_index :issues, :status
    add_index :issues, :priority
    add_index :issues, [:project_id, :status]
  end
end
