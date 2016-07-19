class Ingredient < ActiveRecord::Base
  belongs_to :product_ingredient
  belongs_to :allergy_ingredient
end
