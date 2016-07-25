class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :untrack, :track]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @products = policy_scope(Product)
    if params[:product]
      @product_search = params[:product].downcase
      @result = @products.where(name: @product_search)
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
    product_eatable = false
    @score_zero = @product.reviews.where(score: 0).count
    @score_one = @product.reviews.where(score: 1).count
    @score_two = @product.reviews.where(score: 2).count
    @reviews = @product.reviews.order(updated_at: :desc)

    @product_eatable = true if allergens_in_product.empty?

    authorize @product
  end

  def edit
    authorize @product
  end

  def update


      # after update
      MailProductAlertJob.perform_later(@product.id)
      ### DO ### redirect
  end

  def destroy
  end

  def allergens_in_product
    matching_allergens = []
    user_ingredient_allergen_array = []
    product_allergen_array = []
    @product.allergen_ingredients.each do |product_allergen| #extracts all allergens contained in the product
      product_allergen_array << product_allergen.ingredient
    end
    current_user.allergies.each do |user_allergy|
      user_allergy.ingredients.each do |user_ingredient_allergen|
        user_ingredient_allergen_array << user_ingredient_allergen
      end
    end


    matching_allergens = user_ingredient_allergen_array.select do |allergen|
      product_allergen_array.include?(allergen)
    end
    return matching_allergens
  end


  private

  def product_params
    params.require(:product).permit(:barcode, :name, :updated_on, :manufacturer, :category, :img_url, ingredients_attributes: [:id, :iso_reference, :fr_name, :en_name, :ja_name, :_destroy])
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
