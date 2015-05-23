class User < ActiveRecord::Base
  has_secure_password
  before_save :encrypt_password, :set_auth_token

  validates :username,
    uniqueness: true,
    presence: true
  
  validates :email,
    uniqueness: true,
    presence: true

private

  def encrypt_password
    self.salt = BCrypt::Engine.generate_salt
    self.password_digest = BCrypt::Engine.hash_secret(self.password, self.salt)
  end

  def set_auth_token
    return if self.auth_token
    token = nil
    loop do
      token = SecureRandom.hex
      break token unless User.find_by(auth_token: token)
    end
    self.auth_token = token
  end
  
end
