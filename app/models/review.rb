class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  def average
    inject(&:+) / size
  end

end
