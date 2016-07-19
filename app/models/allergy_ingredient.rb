class AllergyIngredient < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :allergy
end
