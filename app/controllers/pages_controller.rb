class PagesController < ApplicationController

  skip_before_action :authenticate_user!, only: :home
  skip_after_action :verify_authorized

  def home
    if params[:scanresult]
      @barcode = params[:scanresult]
      if @product = Product.find_by(barcode: @barcode)
        redirect_to product_path(@product)
      else
        product = Openfoodfacts::Product.get(@barcode)
        if product
          product.fetch
          @product = Product.create_from_api(product) # creates a product and creates ingredients if new
          redirect_to product_path(@product)
        else
          @message = "Unknown product. Try again."
        end
      end
    end
  end

  def landing

  end

  def allergies_allergens
    @allergies = Allergy.all
    @allergens = AllergyIngredient.all
  end

  def favorites
    @user = current_user
    @favorites = @user.products.all
  end
end
