class RatereviewController < ApplicationController
  #paths for updating a specific users reviews and ratings
  get '/books/:slug/edit' do
    @book = Book.find_by_slug(params[:slug])
    if logged_in?
      erb :'/books/edit'
  end

  patch '/books/:slug' do
    @book = Book.find_by_slug(params[:slug])
    @review = Review.find_by(user_id: current_user)
    @rating = Review.find_by(user_id: current_user)
    if params[:review] != nil
      @book.@review.content = params[:review]
      if params[:rating] != nil
        @book.@rating.value = params[:rating]
        @book.save
        redirect to '/books/#{@book.slug}'
      end
    end
    else
      redirect to '/books/new'
  end

  get '/books/:slug/delete' do
  end
end
