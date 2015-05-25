class User < ActiveRecord::Base
  has_secure_password
  before_save :encrypt_password

  validates :username,
    uniqueness: true,
    presence: true
  
  validates :email,
    uniqueness: true,
    presence: true

  scope :identified_by, ->(identity) { where("username = ? or email = ?", identity, identity).first }

  has_many :authentication_tokens, as: :authenticatable

  attr_accessor :token

private

  def encrypt_password
    self.salt = BCrypt::Engine.generate_salt
    self.password_digest = BCrypt::Engine.hash_secret(self.password, self.salt)
  end

end
