class ProductsController < ApplicationController
  before_action :set_product, only: [:create, :show]

  def index
    @products = policy_scope(Product)
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    @product.save
    authorize @product
    redirect_to product_path
  end

  def show
    authorize @product
  end

  def edit
  end

  def update

      # @product =

      # after update
      MailProductAlertJob.perform_later(@product)
      ### TODO ### redirect
  end

  def destroy
  end

  private

  def product_params
    params.require(:product).permit(:barcode, :name, :updated_on, :manufacturer, :category)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
