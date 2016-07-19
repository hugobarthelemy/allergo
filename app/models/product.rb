class Product < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_brand_and_title, :against => [:manufacturer, :category]

  has_many :ingredients_products
  has_many :reviews
  has_many :scanned_products
  has_many :tracked_products
end
