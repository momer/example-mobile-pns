class User < ActiveRecord::Base
  has_one :device, dependent: :destroy

  validates :email, :sex, presence: true
  
  accepts_nested_attributes_for :device
end