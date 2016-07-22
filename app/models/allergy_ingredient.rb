class AllergyIngredient < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :allergy

  def self.find_or_create_by(allergen_name)
    allergen = allergen_name.split(":")
    case allergen[0]
    when "fr"
      ingredient = Ingredient.find_or_create_by(fr_name: allergen[1])
    when "en"
      ingredient = Ingredient.find_or_create_by(en_name: allergen[1])
    when "ja"
      ingredient = Ingredient.find_or_create_by(ja_name: allergen[1])
    else
      ### TODO ###
    end

    AllergyIngredient.find_or_create_by(ingredient_id: ingredient.id)
  end
end
