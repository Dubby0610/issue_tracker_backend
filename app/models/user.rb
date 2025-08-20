class User < ApplicationRecord
  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  # Associations
  has_many :assigned_issues, class_name: 'Issue', foreign_key: 'assigned_to_id', dependent: :nullify
  has_many :reported_issues, class_name: 'Issue', foreign_key: 'reporter_id', dependent: :restrict_with_error
  has_many :comments, dependent: :destroy
  
  # Scopes
  scope :active, -> { where(is_active: true) }
  
  # Default scope to exclude password from serialization
  def as_json(options = {})
    super(options.merge(except: [:password]))
  end

  # Soft delete
  def soft_delete!
    update!(is_active: false)
  end

  def active?
    is_active
  end
end
