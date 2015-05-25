class AuthenticationToken < ActiveRecord::Base
  belongs_to :authenticatable, polymorphic: true

  before_create :digest_auth_token

  attr_accessor :token

  def self.from_authenticatable(authenticatable)
    instance = self.create(authenticatable: authenticatable, token: generate_token)
    authenticatable.token = instance.token
    instance
  end

  def secure_compare(auth_token)
    a = self.token_digest
    b = digest(auth_token)
    return false if a.blank? || b.blank? || a.bytesize != b.bytesize
    l = a.unpack "C#{a.bytesize}"
    res = 0
    b.each_byte { |byte| res |= byte ^ l.shift }
    res == 0
  end

private

  def digest_auth_token
    self.token_digest = digest(self.token)
  end

  def get_salt
    self.salt ||= BCrypt::Engine.generate_salt
  end

  def digest(token)
    config = Rails.application.config_for(:authentication)
    BCrypt::Engine.hash_secret(token, get_salt, config["work_factor"])
  end

  def self.generate_token
    SecureRandom.hex
  end
end
