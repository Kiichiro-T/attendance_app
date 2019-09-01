class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :event
  default_scope -> { order(created_at: :desc) }
  #attr_accessor :status
  validates :status,   presence: true
  validates :reason,   length: { maximum: 1024 }
  validates :remarks,  length: { maximum: 1024 }
  validates :user_id,  presence: true
  validates :event_id, presence: true
  validates_uniqueness_of :event_id, scope: :user_id
  validate  :presence_2_or_3
  
  
  private
    
    # statusが２または３の時は理由を書く
    def presence_2_or_3
      s = status
      r = reason
      if (s == 2 || s == 3) && r.blank?
        errors.add(:reason, "を書いてください")
      end
    end
end
