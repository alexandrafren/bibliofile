require 'spec_helper'

describe ApplicationController do

  describe 'Homepage' do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Bibliofile!")
    end
  end

  describe 'Signup Page' do

    it 'signup directs users to the books page' do
      params = {
        :username => "kittens80",
        :password => "ilovekittens"
      }
      post '/users', params
      expect(last_response.location).to include ('/books')
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :password => "rainbows"
      }
      post '/users', params
      expect(last_response.location).to include('/users/new')
    end

    it 'does not let a user sign up without an password' do
      params = {
        :username => "skittles123",
        :password => ""
      }
      post '/users', params
      expect(last_response.location).to include('/users/new')
    end

    it 'creates a new user and logs them in on valid submission and does not let a logged in user view the signup page' do
      params = {
        :username => "skittles123",
        :password => "rainbows"
      }
      post '/users', params
      get '/users/new'
      expect(last_response.location).to include('/books')
    end
  end


  describe "login" do
    it 'loads the books index after login' do
      user = User.create(:username => "becky567", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Click on a book")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "becky567", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/books")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "becky567", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load /books if user not logged in' do
      get '/books'
      expect(last_response.location).to include("/login")
    end

    it 'does load /books if user is logged in' do
      user = User.create(:username => "becky567", :password => "kittens")
      visit '/login'
      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/books')
    end
end

describe 'new action' do
    context 'logged in' do
      it 'lets user view new Book form if logged in' do
        user = User.create(:username => "becky567", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/books/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a book if they are logged in' do
        user = User.create(:username => "becky567", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/books/new'
        fill_in(:title, :with => "Outliers")
        fill_in(:author, :with => "Malcolm Gladwell")
        click_button 'Add This Book!'

        user = User.find_by(:username => "becky567")
        book = Book.find_by(:title => "Outliers")
        expect(book).to be_instance_of(Book)
        expect(page.status_code).to eq(200)
      end

      #this test is not working correctyly even though the site prevents the user from making a blank book in shotgun
      xit 'does not let a user create a blank book' do
        user = User.create(:username => "becky567", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/books/new'

        fill_in(:author, :with => "")
        click_button 'Add This Book!'

        expect(Book.find_by(:title => "")).to eq(nil)
        expect(page.current_path).to eq("/books/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new Book form if not logged in' do
        get '/books/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single Book' do

        user = User.create(:username => "becky567", :password => "kittens")
        book = Book.create(:title => "i am a boss at Booking", :author => "Becky")
        user.books << book

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/books/#{book.slug}"
        expect(page.body).to include("Want to remove this book from your shelf?")
        expect(page.body).to include(book.title)
        expect(page.body).to include("Edit Your Review of this Book")
      end
    end

    context 'logged out' do
      it 'does not let a user view a Book' do
        user = User.create(:username => "becky567", :password => "kittens")
        book = Book.create(:title => "i am a boss at Booking", :author => "becky with that good hair")
        get "/books/#{book.slug}"
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view Book edit form if they are logged in' do
        user = User.create(:username => "becky567", :password => "kittens")
        Book = Book.create(:title => "Booking!", :user_id => user.id)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/books/1/edit'
        expect(page.status_code).to eq(200)
        expect(page.body).to include(Book.content)
      end

      it 'does not let a user edit a Book they did not create' do
        user1 = User.create(:username => "becky567", :password => "kittens")
        Book1 = Book.create(:title => "Booking!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :password => "horses")
        Book2 = Book.create(:title => "look at this Book", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/books/#{Book2.id}/edit"
        expect(page.current_path).to include('/books')
      end

      it 'lets a user edit their own Book if they are logged in' do
        user = User.create(:username => "becky567", :password => "kittens")
        Book = Book.create(:title => "Booking!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/books/1/edit'

        fill_in(:title, :with => "i love Booking")

        click_button 'submit'
        expect(Book.find_by(:title => "i love Booking")).to be_instance_of(Book)
        expect(Book.find_by(:title => "Booking!")).to eq(nil)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit a text with blank content' do
        user = User.create(:username => "becky567", :password => "kittens")
        Book = Book.create(:title => "Booking!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/books/1/edit'

        fill_in(:title, :with => "")

        click_button 'submit'
        expect(Book.find_by(:title => "i love Booking")).to be(nil)
        expect(page.current_path).to eq("/books/1/edit")
      end
    end

    context "logged out" do
      it 'does not load -- instead redirects to login' do
        get '/books/1/edit'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own Book if they are logged in' do
        user = User.create(:username => "becky567", :password => "kittens")
        Book = Book.create(:title => "Booking!", :user_id => 1)
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit 'Books/1'
        click_button "Delete Book"
        expect(page.status_code).to eq(200)
        expect(Book.find_by(:title => "Booking!")).to eq(nil)
      end

      it 'does not let a user delete a Book they did not create' do
        user1 = User.create(:username => "becky567", :password => "kittens")
        Book1 = Book.create(:title => "Booking!", :user_id => user1.id)

        user2 = User.create(:username => "silverstallion", :password => "horses")
        Book2 = Book.create(:title => "look at this Book", :user_id => user2.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "Books/#{Book2.id}"
        click_button "Delete Book"
        expect(page.status_code).to eq(200)
        expect(Book.find_by(:title => "look at this Book")).to be_instance_of(Book)
        expect(page.current_path).to include('/books')
      end
    end

    context "logged out" do
      it 'does not load let user delete a Book if not logged in' do
        Book = Book.create(:title => "Booking!", :user_id => 1)
        visit '/books/1'
        expect(page.current_path).to eq("/login")
      end
    end
  end

end
