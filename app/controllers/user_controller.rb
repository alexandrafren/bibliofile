class UserController < ApplicationController
  get '/users' do
    @users = User.all
    erb :'/users/users'
  end

  get '/users/new' do
    if logged_in?
      redirect to '/books'
    else
      erb :'/users/new'
    end
  end

  post '/users' do
    @user = User.new
    if params[:username] != "" && params[:password] != ""
      @user.username = params[:username]
      @user.password = params[:password]
      @user.save
      session[:user_id] = @user.id
      redirect to '/books'
    else
      redirect to '/users/new'
    end
  end

  get '/login' do
    if logged_in?
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
    session.clear
    redirect to '/login'
  end

  get '/user/:slug' do
    @user = User.find_by_slug(params[:slug])
    @books = @user.books
    erb :'/users/show'
  end

end
