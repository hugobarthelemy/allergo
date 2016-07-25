class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :untrack, :track]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @products = policy_scope(Product)
    if params[:product]
      @product_search = params[:product].downcase
      @result = @products.select { |product| product.name.downcase.include?(@product_search) }
    end
  end

  def new
    @product = Product.new
    @ingredient = Ingredient.new
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    @product.save
    authorize @product
    redirect_to product_path(@product)
  end

  def track
    @tracked_product = TrackedProduct.new(product_id: @product.id, user_id: current_user.id).save
    redirect_to product_path(@product)
    authorize @product
  end

  def untrack
    authorize @product
    current_user.products.delete(@product)
    redirect_to product_path(@product)
  end

  def show
    @score_zero = @product.reviews.where(score: 0).count
    @score_one = @product.reviews.where(score: 1).count
    @score_two = @product.reviews.where(score: 2).count
    @reviews = @product.reviews.order(updated_at: :desc)
    authorize @product
  end

  def edit
    authorize @product
  end

  def update


      # after update
      MailProductAlertJob.perform_later(@product.id)
      ### TODO ### redirect
  end

  def destroy
  end


  private

  def product_params
    params.require(:product).permit(:barcode, :name, :updated_on, :manufacturer, :category, ingredients_attributes: [:id, :iso_reference, :fr_name, :en_name, :ja_name, :_destroy])
  end

  def product_ingredient
    params.require(:ingredient).permit(:ingredient)
  end

  def set_product
    if params[:id]
      @product = Product.find(params[:id])
    else
      @product = Product.find(params[:product_id])
    end
  end
end
