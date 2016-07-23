class ReviewsController < ApplicationController
  before_action :find_product, only: [ :new, :create, :edit, :update ]
  before_action :find_review, only: [ :edit, :update]

  def new
    @review = Review.new
    authorize @review
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user
    @review.save
    authorize @review
    redirect_to product_path(@product)
  end

  def edit
    authorize @review
  end

  def update
    @review.update(review_params)
    authorize @review
    redirect_to product_path(@product)
  end

  private

  def review_params
    params.require(:product)[:review].permit(:score, :content)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_review
    @review = Review.find(params[:id])
  end
end
