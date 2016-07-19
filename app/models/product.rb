class Product < ActiveRecord::Base
  has_many :ingredients_products
  has_many :reviews
  has_many :scanned_products
  has_many :tracked_products
end
