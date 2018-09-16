class User < ActiveRecord::Base
  has_many :books
  has_many :books, through: :book_users
  has_secure_password
end
