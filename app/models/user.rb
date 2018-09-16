class User < ActiveRecord::Base
  has_many :book_users
  has_many :books, :through => :book_users
  has_secure_password
end
