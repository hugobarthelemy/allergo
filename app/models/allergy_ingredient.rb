class AllergyIngredient < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :allergy

  def self.define_new(allergen_name)

    if allergen_name.include?(":")
      allergen = allergen_name.split(":")
      case allergen[0]
      when "fr"
        ingredient = Ingredient.find_or_create_by(fr_name: allergen[1])
      when "en"
        ingredient = Ingredient.find_or_create_by(en_name: allergen[1])
      when "ja"
        ingredient = Ingredient.find_or_create_by(ja_name: allergen[1])
      else
        ### TODO ### create "world_name" for unknown language
        ingredient = Ingredient.find_or_create_by(en_name: allergen[1])
      end

      AllergyIngredient.find_or_create_by(ingredient_id: ingredient.id)

    else
      if ingredient = Ingredient.find_by(fr_name: allergen_name)
        ingredient
      else
        if ingredient = Ingredient.find_by(en_name: allergen_name)
          ingredient
        else
          if ingredient = Ingredient.find_by(ja_name: allergen_name)
            ingredient
          else
            ### TODO ### create "world_name" for unknown language
            ingredient = Ingredient.create(en_name: allergen_name)
          end
        end
      end
      AllergyIngredient.find_or_create_by(ingredient_id: ingredient.id)

    end
  end
end
