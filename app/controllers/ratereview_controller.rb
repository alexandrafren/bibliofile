require 'rack-flash'
class RatereviewController < ApplicationController
  use Rack::Flash
  #paths for updating a specific users reviews and ratings
  get '/books/:slug/edit' do
    @book = Book.find_by_slug(params[:slug])
    @review = Review.find_by(user_id: current_user, book_id: @book.id)
    @rating = Rating.find_by(user_id: current_user, book_id: @book.id)
    if logged_in? && current_user.books.include?(@book)
      erb :'/books/edit'
    elsif !logged_in?
      flash[:message] = "You must be logged in to edit a book."
      redirect to '/login'
    elsif current_user.books.include?(@book) == nil
      flash[:message] = "You do not currently have this book on your shelf."
    end
  end

  patch '/books/:slug' do
    @book = Book.find_by_slug(params[:slug])
    @review = Review.find_by(user_id: current_user, book_id: @book.id)
    @rating = Rating.find_by(user_id: current_user, book_id: @book.id)
    if params[:review] != nil && params[:rating] != nil
      @review.content = params[:review]
      @review.save
      @rating.value = params[:rating]
      @rating.save
      redirect to '/books'
    else
      flash[:message] = "Your input was invalid. Please try again."
      redirect to '/books'
    end
  end

  delete '/books/:slug/delete' do
    @book = Book.find_by_slug(params[:slug])
    @book = Book.find_by_slug(params[:slug])
    if logged_in? && current_user.books.include?(@book)
      current_user.books.delete(@book)
      @review = Review.find_by(user_id: current_user, book_id: @book.id)
      @rating = Review.find_by(user_id: current_user, book_id: @book.id)
      @review.destroy
      @rating.destroy
    elsif !logged_in?
      flash[:message] = "You must be logged in to delete a book from your shelf."
      redirect to '/login'
    elsif current_user.books.include?(@book) == nil
      flash[:message] = "You do not have this book saved to your shelf. You can't delete something that doesn't exist!"
    end
    redirect to '/books'
  end

end
