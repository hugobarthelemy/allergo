class Allergy < ActiveRecord::Base
  has_many :levels
  has_many :allergies_ingredients, dependent: :destroy

  has_many :ingredients, through: :allergies_ingredients
end
