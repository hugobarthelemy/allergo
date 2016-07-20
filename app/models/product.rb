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
end
