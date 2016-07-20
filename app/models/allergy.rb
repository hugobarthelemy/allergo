class Allergy < ActiveRecord::Base
  has_many :levels
  accepts_nested_attributes_for :levels

  has_many :allergies_ingredients, dependent: :destroy
  has_many :ingredients, through: :allergies_ingredients

end
