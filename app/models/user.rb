class User < ApplicationRecord
  has_many :events,  dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :answer_events, through: :answers, source: :event
  has_many :active_relationships,  class_name: "Relationship",
                                   foreign_key: "user_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships,  source: :group
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効化する
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # 有効用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), 
                   reset_sent_at: Time.zone.now)
  end
  
   
   # パスワード再設定のメールを送信する 
   def send_password_reset_email
     UserMailer.password_reset(self).deliver_now
   end
   
   # パスワード再設定の期限が切れている場合はtrueを返す
   def password_reset_expired?
     reset_sent_at < 2.hours.ago
   end
   
  def feed
    #Event.where("user_id = ?", id)
    #scope = Event.joins(:answers)
    # Event.joins(:answers).where("answers.user_id = ?", id).order("events.start_date DESC")# .or(Event.where("user_id = ?", id)) ユーザー本人のはまだ表示されない
    #Event.joins(:answers).where("event.user_id = ?", id).or(Answer.where("answers.user_id = ?", id))
    #scope.where("answers.user_id = ?", id).or(scope.where("events.user_id = ?", id))
    #scope.where("events.user_id = ?", id).or(scope.where(id: Answer.where("answers.user_id = ?", id)))
    #scope = Event.joins(:active_relationships)
    #scope.where("active_relationships.group_id = ?" id)
  end
 
  # ユーザーをフォローする
    def follow(group)
      following << group
    end

    # ユーザーをフォロー解除する
    def unfollow(group)
      active_relationships.find_by(group_id: group.id).destroy
    end

    # 現在のユーザーがフォローしてたらtrueを返す
    def following?(group)
      following.include?(group)
    end
  
  private
    
    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase    
    end
    
    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
