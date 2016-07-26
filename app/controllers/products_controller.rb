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

    # @product_eatable = true if allergens_in_product.empty?

    @matching_allergy = allergens_in_product
    # returns :
    # # @matching_allergy => "nok" / "ok"
    # # @matching_intolerance => "nok" / "ok" / "alert"
    # # @allergens_matching_allergy => array of ingredients
    # # @traces_matching_allergy
    # # @allergens_matching_intolerance
    # # @traces_matching_intolerance

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
    @matching_allergy = "nok"
    @matching_intolerance = "nok"
    user_allergens = []
    user_traces = []
    product_allergens = []
    product_traces = []


    @product.allergen_ingredients.each do |product_allergen| #extracts all allergens contained in the product
      product_allergens << product_allergen.ingredient
    end

    @product.trace_ingredients.each do |product_trace| #extracts all allergens contained in the product
      product_traces << product_trace.ingredient
    end

    if current_user.nil?
      @matching_allergy = "not logged"
      @matching_intolerance = "not logged"
    elsif current_user.real_allergies.first.nil? && current_user.intolerances.first.nil?
      @matching_allergy = "empty allergy profile"
      @matching_intolerance = "empty allergy profile"
    else
      current_user.real_allergies.each do |real_allergy|
        real_allergy.allergy.ingredients.each do |allergy_ingredient|
          user_allergens << allergy_ingredient
        end
      end

      current_user.intolerances.each do |intolerance|
        intolerance.allergy.ingredients.each do |intolerance_ingredient|
          user_traces << intolerance_ingredient
        end
      end
    end

    @allergens_matching_allergy = (user_allergens & product_allergens)
    @traces_matching_allergy = (user_allergens & product_traces)
    if @allergens_matching_allergy.blank? && @traces_matching_allergy.blank?
      # TEST : allergène en qte significative correspondant au profil allergique
      # TEST : allergène en qte de trace correspondant au profil allergique
      @matching_allergy = "ok"
      @matching_intolerance = "ok"
    end

    @allergens_matching_intolerance = (user_traces & product_allergens)
    if @allergens_matching_intolerance.blank?
      # TEST : allergène en qte significative correspondant au profil d'intollerent
      @matching_intolerance = "ok"
    end

    @traces_matching_intolerance = (user_traces & product_traces)
    if @traces_matching_intolerance.blank?
      # TEST : allergène en qte de trace correspondant au profil d'intollerent
      @matching_intolerance = "ok"
    else # allergène en qte de trace correspondant au profil d'intollerent
      @matching_intolerance = "alert"
    end

  return @matching_allergy
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
