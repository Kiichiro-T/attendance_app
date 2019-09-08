class Group < ApplicationRecord
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "group_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :user
  belongs_to :user
  has_many :events
  #accepts_nested_attributes_for :passive_relationships
  validates :name,        presence: true, length: { maximum: 50 }
  validates :explanation, presence: true, length: { maximum: 1024 }
  validates :user_id,     presence: true
end
