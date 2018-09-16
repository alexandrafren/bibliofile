class User < ActiveRecord::Base
  has_many :book_users
  has_many :books, :through => :book_users
  has_secure_password


  def slug
    username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    User.all.find{|user| user.slug == slug}
end
end
