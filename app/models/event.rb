class Event < ApplicationRecord
  belongs_to :user #optional: true
  belongs_to :group
  has_many :answers, dependent: :destroy
  has_many :answer_users, through: :answers, source: :user
  #attribute :url_token, :string, default: SecureRandom.hex(10)
  default_scope -> { order(start_date: :desc) }
  mount_uploader :picture, PictureUploader
  validates :event_name,   presence: true, length: { maximum: 50 }
  validate  :start_date_not_before_today
  validate  :end_date_not_before_today
  validates :memo,    length: { maximum: 1024 }
  validates :user_id, presence: true
  validates :url_token, presence: true, uniqueness: true
  validate  :picture_size
  validates :group_id, presence: true
  
  # eventモデルのidをランダムなものとする
  def to_param
    url_token
  end
  
  private
    
    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "は5MB未満にしてください")
      end
    end
    
    def start_date_not_before_today
      errors.add(:start_date, "は今日以降のものを選択してください") if start_date.nil? || start_date < Date.today.to_datetime
    end
    
    def end_date_not_before_today
      errors.add(:end_date, "は今日以降のものを選択してください") if end_date.nil? || end_date < Date.today.to_datetime
    end
end
