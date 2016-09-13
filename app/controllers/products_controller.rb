class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :untrack, :track]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @products = policy_scope(Product)
    if params[:product]
      @product_search = params[:product].downcase
      @result = @products.where(name: @product_search)
    else
      @searched_words = params[:searched_words]
      @products = Product.search_by_manufacturer_and_name(@searched_words)
      if @products.empty?
        products_from_off = Openfoodfacts::Product.search(@searched_words, locale: 'world')
        products_from_off.each do |product|
          product.fetch
          product_full = Product.create_from_api(product) # creates a product and creates ingredients if new
          @products << product_full
        end
      end
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

    @pictos_for_allergies_match_with_profil = pictos_for_allergies_match_with_profil
    @pictos_for_allergies_no_match_with_profil = pictos_for_allergies_no_match_with_profil
    @pictos_for_traces_match_with_profil = pictos_for_traces_match_with_profil
    @pictos_for_traces_no_match_with_profil = pictos_for_traces_no_match_with_profil
    @pictos_alert_for_trace_for_intolerant_profil = pictos_alert_for_trace_for_intolerant_profil
    authorize @product
  end

  def edit
    authorize @product
    @matching_allergy = allergens_in_product
    @ingredient = Ingredient.new()

    @en_ingredients = []
    @fr_ingredients = []
    Ingredient.all.each do |ing|
      @en_ingredients << ing unless ing.en_name.blank?
      @fr_ingredients << ing unless ing.fr_name.blank?
    end

    @en_ingredients = @en_ingredients.sort_by{|ingredient| ingredient.en_name}
    @fr_ingredients = @fr_ingredients.sort_by{|ingredient| ingredient.fr_name}


  end

  def update

      ingredient_id = params[:product][:product_components][:ingredient_id]
      # ingredient = Ingredient.find(ingredient_id)
      product_component = ProductComponent.new(
        ingredient_id: ingredient_id,
        product_id: @product.id,
        amount: params[:product][:amount]
      )
      authorize @product
      if product_component.save
        ## mail to all users who track changed product
        # MailProductAlertJob.perform_later(@product.id)

        ## mail to admins who check validity
        action = "added"
        UserMailer.alert_admins_change(@product.id, ingredient_id, action).deliver_now

        redirect_to edit_product_path
      else
        render :edit
      end

  end


  def allergens_in_product
    matching_allergy = "nok"
    matching_intolerance = "nok"
    user_allergens = []
    user_traces = []
    product_significant_ingredients = []
    product_traces = []


    ## adds allergens to significant ingredients if not detected automatically in ingredients
    @product.allergen_ingredients.each do |allergen|
      product_significant_ingredients << allergen.ingredient
    end


    @product.significant_ingredients.each do |significant_ingredient| #extracts all allergens contained in the product
      product_significant_ingredients << significant_ingredient.ingredient
    end

    @product.allergen_ingredients.each do |allergens|
      product_significant_ingredients << allergens.ingredient
    end
    product_significant_ingredients.uniq!

    @product.trace_ingredients.each do |product_trace| #extracts all allergens contained in the product
      product_traces << product_trace.ingredient
    end

    if current_user.nil?
      matching_allergy = "not logged"
      matching_intolerance = "not logged"
    elsif current_user.real_allergies.first.nil? && current_user.intolerances.first.nil?
      matching_allergy = "empty allergy profile"
      matching_intolerance = "empty allergy profile"
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

    allergens_matching_allergy = (user_allergens & product_significant_ingredients)
    allergens_matching_intolerance = (user_traces & product_significant_ingredients)
    traces_matching_allergy = (user_allergens & product_traces)

    traces_matching_intolerance = (user_traces & product_traces)

    if allergens_matching_allergy.blank? && traces_matching_allergy.blank? && allergens_matching_intolerance.blank?
      # TEST : allergène en qte significative correspondant au profil allergique
      # TEST : allergène en qte de trace correspondant au profil allergique
      matching_allergy = "ok"
      # matching_intolerance = "ok"
      if traces_matching_intolerance.blank?
        # TEST : allergène en qte de trace correspondant au profil d'intollerent
        matching_intolerance = "ok"
      else # allergène en qte de trace correspondant au profil d'intollerent
        matching_intolerance = "alert"
      end
    end

    if matching_intolerance == "nok" || matching_allergy == "nok"
      matching_allergy_or_intolerance = "nok"
    elsif matching_intolerance == "alert"
      matching_allergy_or_intolerance = matching_intolerance
    else
      matching_allergy_or_intolerance = "ok"
    end

######### allergies arrays ###########

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
      product_significant_ingredients - allergens_matching_allergy - allergens_matching_intolerance
    )
    if allergens_not_in_user_allergy == nil
      allergens_not_in_user_allergy = []
    end

    allergies_in_product_not_in_user = []
    if allergens_not_in_user_allergy != nil
      allergens_not_in_user_allergy.each do |ingredient|
        if (ingredient && ingredient.allergies) != nil
          ingredient.allergies.each do |allergy|
            allergies_in_product_not_in_user << allergy.name
          end
        end
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
    if intolerances_not_in_user.first
      intolerances_not_in_user.each do |ingredient|
        if ingredient
          ingredient.allergies.each do |intolerance|
            intolerances_in_product_not_in_user << intolerance.name
          end
        end
      end
      intolerances_in_product_not_in_user.uniq!
    end

  matching_results = {
    matching_allergy_or_intolerance: matching_allergy_or_intolerance,
    allergies_or_intolerance_activated_by_allergens: allergies_or_intolerance_activated_by_allergens,
    allergies_activated_by_traces: allergies_activated_by_traces,
    allergies_in_product_not_in_user: allergies_in_product_not_in_user,
    intolerances_activated_by_traces: intolerances_activated_by_traces,
    intolerances_in_product_not_in_user: intolerances_in_product_not_in_user
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

  def pictos_for_allergies_match_with_profil
    pictos_for_allergies_match_with_profil = []
    allergies_match_with_profil = allergens_in_product[:allergies_or_intolerance_activated_by_allergens]
    allergies_match_with_profil.each do |allergy_match_with_profil|
      case allergy_match_with_profil
      when 'milk'
        pictos_for_allergies_match_with_profil << "picto_allergies/milk_picto.png"
      when 'gluten'
        pictos_for_allergies_match_with_profil << "picto_allergies/gluten_picto.png"
      when 'peanuts'
        pictos_for_allergies_match_with_profil << "picto_allergies/peanuts_picto.png"
      else
      end
    end
    return pictos_for_allergies_match_with_profil
    # return un string <%= image_tag "picto_allergies/...png" %><%= image_tag "picto_allergies/...png" %>
  end

  def pictos_for_allergies_no_match_with_profil
    pictos_for_allergies_no_match_with_profil = []
    allergies_no_match_with_profil = allergens_in_product[:allergies_in_product_not_in_user]
    allergies_no_match_with_profil.each do |allergy_no_match_with_profil|
      case allergy_no_match_with_profil
      when 'milk'
        pictos_for_allergies_no_match_with_profil << "picto_allergies/milk_picto.png"
      when 'gluten'
        pictos_for_allergies_no_match_with_profil << "picto_allergies/gluten_picto.png"
      when 'peanuts'
        pictos_for_allergies_no_match_with_profil << "picto_allergies/peanuts_picto.png"
      else
      end
    end
    return pictos_for_allergies_no_match_with_profil
  end

  def pictos_for_traces_match_with_profil
    pictos_for_traces_match_with_profil = []
    traces_match_with_profil = allergens_in_product[:allergies_activated_by_traces]
    traces_match_with_profil.each do |trace_match_with_profil|
      case trace_match_with_profil
      when 'milk'
        pictos_for_traces_match_with_profil << "picto_allergies/milk_picto.png"
      when 'gluten'
        pictos_for_traces_match_with_profil << "picto_allergies/gluten_picto.png"
      when 'peanuts'
        pictos_for_traces_match_with_profil << "picto_allergies/peanuts_picto.png"
      else
      end
    end
    return pictos_for_traces_match_with_profil
  end

  def pictos_for_traces_no_match_with_profil
    pictos_for_traces_no_match_with_profil = []
    traces_no_match_with_profil = allergens_in_product[:intolerances_in_product_not_in_user]
    traces_no_match_with_profil.each do |trace_no_match_with_profil|
      case trace_no_match_with_profil
      when 'milk'
        pictos_for_traces_no_match_with_profil << "picto_allergies/milk_picto.png"
      when 'gluten'
        pictos_for_traces_no_match_with_profil << "picto_allergies/gluten_picto.png"
      when 'peanuts'
        pictos_for_traces_no_match_with_profil << "picto_allergies/peanuts_picto.png"
      else
      end
    end
    return pictos_for_traces_no_match_with_profil
  end

  def pictos_alert_for_trace_for_intolerant_profil
    pictos_alert_for_trace_for_intolerant_profil = []
    traces_for_intolerant_profil = allergens_in_product[:intolerances_activated_by_traces]
    traces_for_intolerant_profil.each do |trace_for_intolerant_profil|
      case trace_for_intolerant_profil
      when 'milk'
        pictos_alert_for_trace_for_intolerant_profil << "picto_allergies/milk_picto.png"
      when 'gluten'
        pictos_alert_for_trace_for_intolerant_profil << "picto_allergies/gluten_picto.png"
      when 'peanuts'
        pictos_alert_for_trace_for_intolerant_profil << "picto_allergies/peanuts_picto.png"
      else
      end
    end
    return pictos_alert_for_trace_for_intolerant_profil
  end
end
