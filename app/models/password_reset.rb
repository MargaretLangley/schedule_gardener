
class PasswordReset
  include ActiveAttr::Model

  attribute :email, type: String

  validates :email, format: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  validates :email, presence: true
end
