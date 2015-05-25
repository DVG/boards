class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

private

  attr_accessor :current_user

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      user = User.identified_by(options["identity"])
      user.authentication_tokens.any? do |auth_token|
        @current_user = user if auth_token.secure_compare(token)
      end
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { message: 'Bad credentials' }, status: 401
  end

  # constant-time comparison algorithm to prevent timing attacks
  def secure_compare(a, b)
    return false if a.blank? || b.blank? || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"
      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
  end

end
