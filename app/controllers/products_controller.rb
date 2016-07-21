class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit]

  def index
    @products = policy_scope(Product)
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
    authorize @ingredient
    redirect_to product_path(@product)
  end

  def show
    authorize @product
  end

  def edit
    authorize @product
  end

  def update


      # after update
      MailProductAlertJob.perform_later(@product)
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
    @product = Product.find(params[:id])
  end
end
