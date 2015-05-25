class SessionsSerializer < ActiveModel::Serializer
  attributes :auth_token, :current_username, :current_email

  def current_username
    object.username
  end

  def current_email
    object.email
  end

  def auth_token
    object.token
  end
end