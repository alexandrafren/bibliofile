class BookController < ApplicationController
  get '/books' do
    @books = Book.all
    erb :'/books/books'
  end

  get '/books/new' do
  end

  get '/books/:id/edit' do
  end

  get '/books/:id/delete' do
  end

  get '/books/:id' do
  end

end
