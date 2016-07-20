class Allergy < ActiveRecord::Base
  has_many :levels
  has_many :allergies_ingredients
  accepts_nested_attributes_for :levels
end
