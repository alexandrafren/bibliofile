class UserController < ApplicationController
  get '/users' do
    @users = User.all
    erb :'/users/users'
  end

  get '/users/new' do
    erb :'/users/new'
  end

  post '/users' do
    @user = User.new
    @user.username = params[:username]
    @user.password = params[:password]
    @user.save
    session[:user_id] = @user.id
    binding.pry
    redirect to '/books'
  end
end
