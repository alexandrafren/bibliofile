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

    it 'does load /tweets if user is logged in' do
      user = User.create(:username => "becky567", :password => "kittens")
      visit '/login'
      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq('/books')
    end
end



end
