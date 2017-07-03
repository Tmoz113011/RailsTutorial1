class User < ApplicationRecord
  attr_reader :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@(?:[A-Z0-9-]+\.)+[A-Z]+\z/i

  validates :name, presence: true,
    length: {maximum: Settings.validates.username.maxium}
  validates :email, presence: true,
    length: {maximum: Settings.validates.email.maxium},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.validates.password.minium}, allow_nil: true

  has_secure_password

  before_save :email_downcase

  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.blank?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attributes remember_digest: nil
  end

  private
  def email_downcase
    self.email = email.downcase
  end
end
