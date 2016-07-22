class Product < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_brand_and_title,
                  :against => [:manufacturer, :category]
                  #:ignoring => :accents
                  #:using => :trigram

  has_many :product_components, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :scanned_products, dependent: :destroy
  has_many :tracked_products, dependent: :destroy

  has_many :ingredients, through: :product_components

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
    new_product.save

    product_api.ingredients.each do |ingredient|

      new_product.ingredients << Ingredient.create_from_api(ingredient.id, product_api.lc)

      # new_product.ingredients.new(Ingredient.create_from_api(ingredient.id, product_api.lc))
    end



  end

  def compare_ingredients_from_api
    ### TODO ##
  end
end
