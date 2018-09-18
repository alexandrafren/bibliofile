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
end
