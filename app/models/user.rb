class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@(?:[A-Z0-9-]+\.)+[A-Z]+\z/i

  validates :name, presence: true,
    length: {maximum: Settings.validates.username.maxium}
  validates :email, presence: true,
    length: {maximum: Settings.validates.email.maxium},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.validates.password.minium}

  has_secure_password

  before_save :email_downcase

  private
  def email_downcase
    self.email = email.downcase
  end
end
