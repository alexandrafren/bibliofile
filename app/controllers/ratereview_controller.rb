class RatereviewController < ApplicationController
  #paths for updating a specific users reviews and ratings
  get '/books/:slug/edit' do
    @book = Book.find_by_slug(params[:slug])
    if logged_in?
      erb :'/books/edit'
    end
  end

  patch '/books/:slug' do
    @book = Book.find_by_slug(params[:slug])
    @review = Review.find_by(user_id: current_user, book_id: @book.id)
    @rating = Review.find_by(user_id: current_user, book_id: @book.id)
    if params[:review] != nil
      @review.content = params[:review]
      @review.save
      if params[:rating] != nil
        @rating.value = params[:rating]
        @rating.save
        redirect to '/books/#{@book.slug}'
      end
    end
  end

  delete '/books/:slug/delete' do
    @book = Book.find_by_slug(params[:slug])
    @review = Review.find_by(user_id: current_user, book_id: @book.id)
    @rating = Review.find_by(user_id: current_user, book_id: @book.id)
    @review.delete
    @rating.delete
    redirect to '/books'
  end
end
