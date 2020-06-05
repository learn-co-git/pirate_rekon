class User < ActiveRecord::Base
  has_secure_password
  has_many :collections
  has_many :images, through: :collections
end
