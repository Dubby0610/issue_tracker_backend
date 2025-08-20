class Project < ApplicationRecord
  # Enums
  enum status: {
    active: 'active',
    on_hold: 'on_hold', 
    completed: 'completed',
    archived: 'archived'
  }
  
  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 200 }
  validates :description, length: { maximum: 5000 }, allow_blank: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  
  # Associations
  has_many :issues, dependent: :destroy
  
  # Instance methods
  def issues_count
    issues.count
  end

  # Serialization
  def as_json(options = {})
    json = super(options)
    json['issues_count'] = issues_count unless options[:exclude_count]
    json
  end
end
