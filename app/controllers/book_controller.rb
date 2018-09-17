class BookController < ApplicationController
  get '/books' do
    @books = Book.all
    erb :'/books/books'
  end

  get '/books/new' do
    erb :'/books/new'
  end

  post '/books' do
    @user = current_user
    @book = Book.find_or_create_by(title: params[:title])
    @book.author = params[:author]
    @book.save
    @user.books << @book
    BookUser.new(user_id: current_user.id, book_id: @book.id, rating: params[:rating], review: params[:review])
    redirect to '/books'
  end

  get '/books/:slug/edit' do
  end

  get '/books/:slug/delete' do
  end

  get '/books/:slug' do
  end

end
