class ReviewsController < ApplicationController
  before_action :find_product, only: [ :new, :create ]

  def new
    @review = Review.new
    authorize @review
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.save
    authorize @review
    redirect_to product_path(@product)
  end

  private

  def review_params
    params.require(:review).permit(:score, :content)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end
end
