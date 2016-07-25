class Product < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_manufacturer_and_name,
                  :against => [:manufacturer, :name]
                  #:ignoring => :accents
                  #:using => :trigram

  has_many :product_components, dependent: :destroy
  has_many :significant_ingredients, -> { where "amount = 2" },
    class_name: "ProductComponent"
  has_many :trace_ingredients, -> { where "amount = 1" },
    class_name: "ProductComponent"

  has_many :reviews, dependent: :destroy
  has_many :scanned_products, dependent: :destroy
  has_many :tracked_products, dependent: :destroy

  has_many :ingredients, through: :product_components

  include AlgoliaSearch

  algoliasearch do
    attribute :name, :manufacturer

    attributesToIndex ['name', 'manufacturer']
  end

  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reviews
  # permet de passer les attributs de la classe ingredient dans les params de la classe product dans le controller product
  # params.require(:product).permit(:barcode, :name, :updated_on, :manufacturer, :category, ingredients_attributes: [:id, :iso_reference :fr_name :en_name :ja_name, :_destroy])
  def self.create_from_api(product_api)
    barcode = product_api.code

    p_name = product_api.product_name
    p_updated_on = product_api.last_edit_dates_tags.first.to_date

    manufacturer = product_api.brands
    # manufacturer = product.brands_tags
    # manufacturer = manufacturer.join(',') unless manufacturer.nil?

    categories = product_api.categories_tags
    categories = categories.join(',') unless categories.nil?
    p_ingredients = []
    p_ingredients = product_api.ingredients


    new_product = Product.new(
      barcode:barcode,
      name: p_name,
      updated_on: p_updated_on,
      manufacturer: manufacturer,
      category: categories
    )
    # new_product.save!
    new_product.save!

    product_api.ingredients.each do |ingredient|
      # creation de la liste d'ingredients du produit
      product_ingredient = Ingredient.create_from_api(ingredient.id, product_api.lc)
      new_product.ingredients << product_ingredient
      new_product.product_components.find_by(ingredient_id: product_ingredient.id).update!(amount: 2)
    end

    if product_api.allergens_tags
      # if product_api.allergens_tags.class == String
      #   # creation de la liste d'allergènes
      #   AllergyIngredient.find_or_create_by(product_api.allergens_tags)
      # else
        # product_allergens = []
        # product_allergens << product_api.allergens_tags

        product_api.allergens_tags.each do |allergen|
          # creation de la liste d'allergènes
          AllergyIngredient.define_new(allergen)
        end
      # end
    end

    if product_api.traces_tags
      product_api.traces_tags.each do |trace|
        ProductComponent.create_trace_from_api(trace, new_product)
      end
    end
  end

  def compare_ingredients_from_api
    ### TODO ##
  end
end
