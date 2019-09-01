class Event < ApplicationRecord
  belongs_to :user #optional: true
  has_many :answers, dependent: :destroy
  has_many :answer_users, through: :answers, source: :user
  #attribute :url_token, :string, default: SecureRandom.hex(10)
  default_scope -> { order(date: :desc) }
  mount_uploader :picture, PictureUploader
  validates :event_name,   presence: true, length: { maximum: 50 }
  validates :date,    presence: true
  validates :memo,    length: { maximum: 1024 }
  validates :user_id, presence: true
  validates :url_token, presence: true, uniqueness: true
  validate  :picture_size
  
  # eventモデルのidをランダムなものとする
  def to_param
    url_token
  end
  
  private
    
    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "5MB未満にしてください")
      end
    end
end
