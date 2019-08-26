class Event < ApplicationRecord
  belongs_to :user, optional: true
  default_scope -> { order(date: :desc) }
  validates :event,   presence: true, length: { maximum: 50 }
  validates :date,    presence: true
  validates :memo,    length: { maximum: 1024 }
  validates :user_id, presence: true
end
