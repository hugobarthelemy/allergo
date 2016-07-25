class ProductComponent < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :product

  def self.create_allergen_or_trace_from_api(ingredient_api_name, new_product, amount)
    if ingredient_api_name.include?(":")
      ingredient_api = ingredient_api_name.split(":")
      case ingredient_api[0]
      when "fr"
        ingredient = Ingredient.find_or_create_by(fr_name: ingredient_api[1])
      when "en"
        ingredient = Ingredient.find_or_create_by(en_name: ingredient_api[1])
      when "ja"
        ingredient = Ingredient.find_or_create_by(ja_name: ingredient_api[1])
      else
        ### TODO ### create "world_name" for unknown language
        ingredient = Ingredient.find_or_create_by(en_name: ingredient_api[1])
      end
    else
      if ingredient = Ingredient.find_by(fr_name: ingredient_api_name)
        ingredient
      else
        if ingredient = Ingredient.find_by(en_name: ingredient_api_name)
          ingredient
        else
          if ingredient = Ingredient.find_by(ja_name: ingredient_api_name)
            ingredient
          else
            ### TODO ### create "world_name" for unknown language
            ingredient = Ingredient.create(en_name: ingredient_api_name)
          end
        end
      end
    end

    trace_or_allergen_products = ProductComponent.where(product_id: new_product.id,
                                              ingredient_id: ingredient.id,
                                              amount: amount
                                            ).first_or_create
  end
end
