class Micropost < ApplicationRecord
  belongs_to :user

  mount_uploader :picture, PictureUploader

  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.maximum}
  validate :picture_size

  scope :desc, ->{order created_at: :desc}

  private

  def picture_size
    return unless picture.size > 5.megabytes
    errors.add :picture, I18n.t(".error")
  end
end
