class Product < ActiveRecord::Base
  has_many :product_components, dependent: :destroy
  has_many :reviews
  has_many :scanned_products
  has_many :tracked_products

  has_many :ingredients, through: :product_components
end
