class PagesController < ApplicationController

  skip_before_action :authenticate_user!, only: :home
  skip_after_action :verify_authorized

  def home
    if params[:scanresult]
      @barcode = params[:scanresult]
      if @product = Product.find_by(barcode: @barcode)
        redirect_to product_path(@product)
      else
        @product = Openfoodfacts::Product.get(@barcode, locale: 'fr')
        if product
          product.fetch
          Product.create_from_api(product) # creates a product and creates ingredients if new
        else
          @message = "Unknown product. Try again."
        end
      end
    end
  end

  def ingredient_show_mobile
    @product = Product.find(params[:id])
  end

  def reviews_show_mobile
    @product = Product.find(params[:id])
  end
end
