class User < ApplicationRecord
  has_secure_password

  has_many :video_rooms

  validates_presence_of :email, :name
  validates_uniqueness_of :email, :name
end
