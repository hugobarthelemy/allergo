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
    # matching_results = {
    #   matching_allergy_or_intolerance:  => "nok" / "ok" / "alert",
    #   allergens_matching_allergy:  => array of ingredients,
    #   traces_matching_allergy: traces_matching_allergy,
    #   allergens_matching_intolerance: allergens_matching_intolerance,
    #   traces_matching_intolerance: traces_matching_intolerance
    # }
    # # @matching_intolerance
    # # @allergens_matching_allergy
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

    allergens_matching_allergy = (user_allergens & product_allergens)
    allergens_matching_intolerance = (user_traces & product_allergens)
    traces_matching_allergy = (user_allergens & product_traces)

    traces_matching_intolerance = (user_traces & product_traces)

    if allergens_matching_allergy.blank? && traces_matching_allergy.blank? && allergens_matching_intolerance.blank?
      # TEST : allergène en qte significative correspondant au profil allergique
      # TEST : allergène en qte de trace correspondant au profil allergique
      @matching_allergy = "ok"
      # @matching_intolerance = "ok"
      if traces_matching_intolerance.blank?
        # TEST : allergène en qte de trace correspondant au profil d'intollerent
        @matching_intolerance = "ok"
      else # allergène en qte de trace correspondant au profil d'intollerent
        @matching_intolerance = "alert"
      end
    end

    if @matching_intolerance == "nok" || @matching_allergy == "nok"
      matching_allergy_or_intolerance = "nok"
    elsif @matching_intolerance == "alert"
      matching_allergy_or_intolerance = @matching_intolerance
    else
      matching_allergy_or_intolerance = "ok"
    end

########## allergies arrays ###########

    allergens_matching_allergy_or_intolerance = allergens_matching_allergy + allergens_matching_intolerance

    allergies_or_intolerance_activated_by_allergens = []
    allergens_matching_allergy_or_intolerance.each do |ingredient|
      ingredient.allergies.each do |allergy|
        allergies_or_intolerance_activated_by_allergens << allergy.name
      end
    end
    allergies_or_intolerance_activated_by_allergens.uniq!

    allergies_activated_by_traces = []
    traces_matching_allergy.each do |ingredient|
      ingredient.allergies.each do |allergy|
        allergies_activated_by_traces << allergy.name
      end
    end
    allergies_activated_by_traces.uniq!

    allergens_not_in_user_allergy = (
      product_allergens + product_traces - allergens_matching_allergy - allergens_matching_intolerance
    )
    allergies_in_product_not_in_user = []
    allergens_not_in_user_allergy.each do |ingredient|
      ingredient.allergies.each do |allergy|
        allergies_in_product_not_in_user << allergy.name
      end
    end
    allergies_in_product_not_in_user.uniq!

    intolerances_activated_by_traces = []
    traces_matching_intolerance.each do |ingredient|
      ingredient.allergies.each do |intolerance|
        intolerances_activated_by_traces << intolerance.name # case "alert"
      end
    end
    intolerances_activated_by_traces.uniq! # case "alert"

    intolerances_not_in_user = (
      product_traces - traces_matching_intolerance - traces_matching_allergy
    )
    intolerances_in_product_not_in_user = []
    intolerances_not_in_user.each do |ingredient|
      ingredient.allergies.each do |intolerance|
        intolerances_in_product_not_in_user << intolerance.name
      end
    end
    intolerances_in_product_not_in_user.uniq!


  matching_results = {
    matching_allergy_or_intolerance: matching_allergy_or_intolerance,
    allergies_or_intolerance_activated_by_allergens: allergies_or_intolerance_activated_by_allergens,
    allergies_activated_by_traces: allergies_activated_by_traces,
    allergies_in_product_not_in_user: allergies_in_product_not_in_user,
    intolerances_activated_by_traces: intolerances_activated_by_traces
  }
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
