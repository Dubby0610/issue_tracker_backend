class Issue < ApplicationRecord
  # Enums
  enum status: {
    active: 'active',
    on_hold: 'on_hold',
    resolved: 'resolved',
    closed: 'closed'
  }
  
  enum priority: {
    low: 'low',
    medium: 'medium',
    high: 'high',
    critical: 'critical'
  }
  
  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 500 }
  validates :description, length: { maximum: 5000 }, allow_blank: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :priority, presence: true, inclusion: { in: priorities.keys }
  validates :project_id, presence: true
  validates :reporter_id, presence: true
  
  # Associations
  belongs_to :project
  belongs_to :assigned_to, class_name: 'User', optional: true
  belongs_to :reporter, class_name: 'User'
  has_many :comments, dependent: :destroy
  
  # Scopes
  scope :by_status, ->(status) { where(status: status) }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :assigned_to_user, ->(user_id) { where(assigned_to_id: user_id) }
  scope :reported_by_user, ->(user_id) { where(reporter_id: user_id) }

  # Serialization with associations
  def as_json(options = {})
    json = super(options)
    
    if options[:include_associations]
      json['assigned_to'] = assigned_to&.as_json(only: [:id, :name, :email])
      json['reporter'] = reporter&.as_json(only: [:id, :name, :email])
      json['project'] = project&.as_json(only: [:id, :name])
      json['comments'] = comments.includes(:user).map do |comment|
        comment.as_json.merge('user' => comment.user.as_json(only: [:id, :name, :email]))
      end if options[:include_comments]
    end
    
    json
  end
end
