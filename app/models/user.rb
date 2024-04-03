require_relative "../../config/database"

class User < Sequel::Model

  def validate
    super
    errors.add(:username, 'cannot be blank') if username.nil? || username.empty?
    errors.add(:password, 'cannot be blank') if password.nil? || password.empty?
    errors.add(:username, 'must be unique') if User.where(username: username).count > 0
  end
end