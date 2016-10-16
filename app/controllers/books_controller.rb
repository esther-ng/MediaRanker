class BooksController < ApplicationController
  def index
    @books = Book.by_rank
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to book_path(@book)
    else
      render :new
    end
  end

  def show
    begin
      @book = Book.find(params[:id])
    rescue ActiveRecord::RecordNotFound => err
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if request.patch?
      @book.upvote
    else
      @book.update(book_params)
    end

    if @book.save
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    redirect_to books_path
  end

  # def upvote #is there a way to incorporate this to update to use with patch vs put?
  #   @book = Book.find(params[:id])
  #   @book.ranked += 1
  #   @book.save
  #
  #   redirect_to book_path(@book.id)
  # end

  private

  def book_params
    params.require(:book).permit(:title, :by, :description, :ranked)
  end
end
