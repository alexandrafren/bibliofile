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
    Rating.create(user_id: current_user.id, book_id: @book.id, value: params[:rating])
    Review.create(user_id: current_user.id, book_id: @book.id, content: params[:review])
    binding.pry
    redirect to '/books'
  end

  get '/books/:slug/edit' do
    @book = Book.find_by_slug(params[:slug])
    erb :'/books/edit'
  end

  patch '/books/:slug' do
    @book = Book.find_by_slug(params[:slug])
    if params[:review] != nil
      @book.review.content = params[:review]
      if params[:rating] != nil
        @book.rating.value = params[:rating]
        @book.save
        redirect to '/books/#{@book.slug}'
      end
    end
    else
      redirect to '/books/new'
  end

  get '/books/:slug/delete' do
  end

  get '/books/:slug' do
  end

end
