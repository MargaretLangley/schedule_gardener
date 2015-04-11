
class PasswordReset
  include ActiveAttr::Model
  include ActiveAttr::MassAssignment

  attr_accessible :email
  attribute :email, type: String

  validates_format_of :email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  validate :email, presence: true
end
