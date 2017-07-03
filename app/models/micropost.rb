class Micropost < ApplicationRecord
  belongs_to :user

  mount_uploader :picture, PictureUploader

  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.maximum}
  validate :picture_size

  scope :desc, ->{order created_at: :desc}
  scope :get_feed, ->id do
    where("user_id IN (SELECT followed_id
      FROM relationships WHERE follower_id = :user_id)
        OR user_id = :user_id", user_id: id)
  end

  private

  def picture_size
    return unless picture.size > 5.megabytes
    errors.add :picture, I18n.t(".error")
  end
end
