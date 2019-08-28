class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :event
  #attr_accessor :status
  validates :status,   presence: true
  validates :reason,   presence: true, length: { maximum: 1024 }
  validates :remarks,  length: { maximum: 1024 }
  validates :user_id,  presence: true
  validates :event_id, presence: true
  validates_uniqueness_of :event_id, scope: :user_id
  
  # statusが2, 3の時true, 1の時falseを返す
  #def is_status_not_1?
  #  self.status == 1
  #end
end
