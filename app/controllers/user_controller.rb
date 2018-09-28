require 'rack-flash'
class UserController < ApplicationController
  use Rack::Flash

  get '/users' do
    redirect_if_not_logged_in
    @users = User.all
    erb :'/users/users'
  end

  get '/users/new' do
    if logged_in?
      flash[:message] = "You were already logged in! Redirected to Books"
      redirect to '/books'
    else
      erb :'/users/new'
    end
  end

  post '/users' do
    user = User.find_by(username: params[:username])
    if params[:username] != "" && params[:password] != ""&& user != nil
      @user = User.new
      @user.username = params[:username]
      @user.password = params[:password]
      @user.save
      session[:user_id] = @user.id
      redirect to '/books'
    else
      flash[:message] = "Invalid Entries. Please try again."
      redirect to '/users/new'
    end
  end

  get '/login' do
    if logged_in?
      flash[:message] = "You were already logged in! Redirected to Books"
      redirect to '/books'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && (@user.authenticate(params[:password]))
      session[:user_id] = @user.id
      redirect to '/books'
    else
      redirect to '/users/new'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      flash[:message] = "Logged Out!"
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  get '/user/:slug' do
    @user = User.find_by_slug(params[:slug])
    @books = @user.books
    erb :'/users/show'
  end

end
