class Allergy < ActiveRecord::Base
  has_many :levels, dependent: :destroy
  accepts_nested_attributes_for :levels

  has_many :allergy_ingredients, dependent: :destroy
  has_many :ingredients, through: :allergy_ingredients
end
