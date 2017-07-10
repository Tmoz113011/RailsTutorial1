class Micropost < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.maximum}

  scope :desc, ->{order created_at: :desc}
end
