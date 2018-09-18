books_list = {
    "book1" => {
      :title => "The Wonky Donkey",
      :author => "Craig Smith"
    },
    "book2" => {
      :title => "A Little History of Economics",
      :author => "Niall Kishtainy"
    },

    "book3" => {
      :title => "Girl, Wash Your Face",
      :author => "Rachel Hollis"
    },
    "book4" => {
      :title => "Harry Potter and The Sorcerers Stone",
      :author => "J.K. Rowling"
    }
  }

books_list.each do |name, book_hash|
  name = Book.new
  book_hash.each do |attribute, value|
      name[attribute] = value
  end
  name.save
end

user_list = {
    "Becky" => {
      :username => "beckyloveskittens",
      :password_digest => "kittens"
    },
    "Mark" => {
      :username => "markymark",
      :password_digest => "wahlburgers"
    },
    "Ian" => {
      :username => "iturner123",
      :password_digest => "testing"
    }
  }

user_list.each do |name, user_hash|
  name = User.new
  user_hash.each do |attribute, value|
      name[attribute] = value
  end
  name.save
end


ratings_list = {
    "r1" => {
      :user_id => 1,
      :book_id => 1,
      :value => 5
    },
    "r2" => {
      :user_id => 1,
      :book_id => 3,
      :value => 5
    },
    "r3" => {
      :user_id => 2,
      :book_id => 2,
      :value => 4
    },
    "r4" => {
      :user_id => 3,
      :book_id => 4,
      :value => 2
    },
    "r5" => {
      :user_id => 3,
      :book_id => 2,
      :value => 5
    }
  }

  ratings_list.each do |name, rating_hash|
    name = Rating.new
    rating_hash.each do |attribute, value|
        name[attribute] = value
    end
    name.save
    user = User.find_by_id(rating_hash[:user_id])
    book = Book.find_by_id(rating_hash[:book_id])
    user.books << book
  end

  reviews_list = {
      "r1" => {
        :user_id => 1,
        :book_id => 1,
        :content => "Who doesn't love a Donkey? Especially a wonky one."
      },
      "r2" => {
        :user_id => 1,
        :book_id => 3,
        :content => "I DO need to wash my face."
      },
      "r3" => {
        :user_id => 2,
        :book_id => 2,
        :content => "I would have loved to read a big history of economics."
      },
      "r4" => {
        :user_id => 3,
        :book_id => 4,
        :content => "Dope."
      },
      "r5" => {
        :user_id => 3,
        :book_id => 2,
        :content => "I love the philosophical discussions of immortality."
      }
    }

    reviews_list.each do |name, review_hash|
      name = Review.new
      review_hash.each do |attribute, value|
          name[attribute] = value
      end
      name.save
    end
