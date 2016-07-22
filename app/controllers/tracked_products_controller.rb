class TrackedProductsController < ApplicationController

  def create
    @product = Product.find(params[:product_id])
    @tracked_product = TrackedProduct.new(product_id: @product.id, user_id: current_user.id).save
    redirect_to product_path(@product)
    authorize @product
  end

  def destroy
    @product = Product.find(params[:product_id])
    @tracked_product = TrackedProduct.where(:user_id=>params[:user_id]).where(:product_id=>params[:product_id]).first

    redirect_to product_path(@product)
    @tracked_product.delete
  end
end


