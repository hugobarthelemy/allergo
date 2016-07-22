class Product < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_brand_and_title,
                  :against => [:manufacturer, :category]
                  #:ignoring => :accents
                  #:using => :trigram

  has_many :product_components, dependent: :destroy
  has_many :reviews
  has_many :scanned_products
  has_many :tracked_products

  has_many :ingredients, through: :product_components

  include AlgoliaSearch

  algoliasearch do
    attribute :name, :manufacturer

    attributesToIndex ['name', 'manufacturer']
  end

  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  # permet de passer les attributs de la classe ingredient dans les params de la classe product dans le controller product
  # params.require(:product).permit(:barcode, :name, :updated_on, :manufacturer, :category, ingredients_attributes: [:id, :iso_reference :fr_name :en_name :ja_name, :_destroy])
end
