class Ingredient < ActiveRecord::Base
  has_many :allergy_ingredient
  has_many :product_components

end
