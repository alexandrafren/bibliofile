require 'rack-flash'
class BookController < ApplicationController
  use Rack::Flash
  get '/books' do
    if logged_in?
      @books = Book.all
      erb :'/books/books'
    else
      flash[:message] = "You must be logged in to view that page."
      redirect to '/login'
    end
  end

  get '/books/new' do
    if logged_in?
      erb :'/books/new'
    else
      flash[:message] = "You must be logged in to view that page."
      redirect to '/login'
    end
  end

 post '/book/:slug' do
   @book = Book.find_by_slug(params[:slug])
   @user = current_user
   @user.books << @book
   Rating.create(user_id: current_user.id, book_id: @book.id, value: params[:rating])
   Review.create(user_id: current_user.id, book_id: @book.id, content: params[:review])
   redirect to '/books'
 end

  post '/books' do
    @user = current_user
    @book = Book.find_or_create_by(title: params[:title])
    if params[:title] != "" && params[:author] != ""
      @book.author = params[:author]
      @book.save
      @user.books << @book
      Rating.create(user_id: current_user.id, book_id: @book.id, value: params[:rating])
      Review.create(user_id: current_user.id, book_id: @book.id, content: params[:review])
      redirect to '/books'
    else
      flash[:message] = "Part of your entry was invalid. Please try again."
      redirect to '/books/new'
    end
  end

  get '/books/new/:slug' do
    @book = Book.find_by_slug(params[:slug])
    erb :'/books/find_by'
  end



  get '/books/:slug' do
    if logged_in?
      @book = Book.find_by_slug(params[:slug])
      erb :'/books/show'
    else
      flash[:message] = "You must be logged in to view that content."
      redirect to '/login'
    end
  end



end
