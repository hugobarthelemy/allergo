class TrackedProductsController < ApplicationController

  def create
    @product = Product.find(params[:product_id])
    redirect_to product_path(@product)
    authorize @product
  end

  def destroy
  end
end
