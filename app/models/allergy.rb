class Allergy < ActiveRecord::Base
  has_many :levels
  has_many :allergies_ingredients
end
