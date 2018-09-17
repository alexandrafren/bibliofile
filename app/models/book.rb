class Book < ActiveRecord::Base
  has_many :book_users
  has_many :ratings
  has_many :reviews
  has_many :users, :through => :book_users

    def slug
      title.downcase.gsub(" ","-")
    end

    def self.find_by_slug(slug)
      Book.find{|user| user.slug == slug}
    end

end
