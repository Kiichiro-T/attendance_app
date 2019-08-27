class Event < ApplicationRecord
  belongs_to :user, optional: true
  default_scope -> { order(date: :desc) }
  mount_uploader :picture, PictureUploader
  validates :event_name,   presence: true, length: { maximum: 50 }
  validates :date,    presence: true
  validates :memo,    length: { maximum: 1024 }
  validates :user_id, presence: true
  validate  :picture_size
  
  private
    
    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "5MB未満にしてください")
      end
    end
end
