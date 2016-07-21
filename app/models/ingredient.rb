class Ingredient < ActiveRecord::Base
  has_many :allergy_ingredients
  has_many :product_components

end
