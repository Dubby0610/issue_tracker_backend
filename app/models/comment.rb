class Comment < ApplicationRecord
  # Validations
  validates :content, presence: true, length: { minimum: 1, maximum: 5000 }
  validates :issue_id, presence: true
  validates :user_id, presence: true
  
  # Associations
  belongs_to :issue
  belongs_to :user
  
  # Scopes
  scope :internal, -> { where(is_internal: true) }
  scope :external, -> { where(is_internal: false) }
  scope :chronological, -> { order(:created_at) }

  # Serialization with user association
  def as_json(options = {})
    json = super(options)
    
    if options[:include_user] != false
      json['user'] = user.as_json(only: [:id, :name, :email])
    end
    
    json
  end
end
