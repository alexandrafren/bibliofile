class UserController < ApplicationController
  get '/users' do
    @users = User.all
    erb :'/users/users'
  end

  get '/signup' do
    erb :'/users/new'
  end
end
