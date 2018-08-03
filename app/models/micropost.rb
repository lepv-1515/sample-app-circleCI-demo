class Micropost < ApplicationRecord
  belongs_to :user

  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.max_content}
  validate :picture_size

  scope :newest, ->{order created_at: :desc}
  scope :by_follow, ->(following_ids, id){where "user_id IN (?) OR user_id = ?", following_ids, id}

  private

  def picture_size
    return unless picture.size > Settings.max_size_image.megabytes
    errors.add(:picture, I18n.t("micropost.picture_size"))
  end
end
