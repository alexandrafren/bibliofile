class BookController < ApplicationController
  get '/books' do
    if logged_in?
      @books = Book.all
      erb :'/books/books'
    else
      redirect to '/login'
    end
  end

  get '/books/new' do
    if logged_in?
      erb :'/books/new'
    else
      redirect to '/login'
    end
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
      redirect to '/books/new'
    end
  end

  get '/books/new/:slug' do
    @book = Book.find_by_slug(params[:slug])
    erb :'/books/find_by'
  end

  post '/books/:slug' do
    @book = Book.find_by_slug(params[:slug])
    @user = current_user
    @user.books << @book
    Rating.create(user_id: current_user.id, book_id: @book.id, value: params[:rating])
    Review.create(user_id: current_user.id, book_id: @book.id, content: params[:review])
    redirect to '/books'
  end

  get '/books/:slug' do
    if logged_in?
      @book = Book.find_by_slug(params[:slug])
      erb :'/books/show'
    else
      redirect to '/login'
    end
  end

  #delete method
  get 'books/:slug/delete' do
    @book = Book.find_by_slug(params[:slug])
    current_user.books.delete(@book)
  end

end
