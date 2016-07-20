class ProductsController < ApplicationController
  before_action :product_params, only: [:create, :show]
  before_action :set_product, only: [:create, :show]
  def index
    @products = policy_scope(Product)
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    authorize @product
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def product_params
    params.require(:product).permit(:id, :barcode, :name, :updated_on, :manufacturer, :category)
  end

  def set_product
    @product = Product.find(product_params)
  end
end
