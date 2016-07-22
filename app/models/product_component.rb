class ProductComponent < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :product

  def self.create_trace_from_api(trace_name, new_product)
    if trace_name.include?(":")
      trace = trace_name.split(":")
      case trace[0]
      when "fr"
        ingredient = Ingredient.find_or_create_by(fr_name: trace[1])
      when "en"
        ingredient = Ingredient.find_or_create_by(en_name: trace[1])
      when "ja"
        ingredient = Ingredient.find_or_create_by(ja_name: trace[1])
      else
        ### TODO ### create "world_name" for unknown language
        ingredient = Ingredient.find_or_create_by(en_name: trace[1])
      end


    else
      if ingredient = Ingredient.find_by(fr_name: trace_name)
        ingredient
      else
        if ingredient = Ingredient.find_by(en_name: trace_name)
          ingredient
        else
          if ingredient = Ingredient.find_by(ja_name: trace_name)
            ingredient
          else
            ### TODO ### create "world_name" for unknown language
            ingredient = Ingredient.create(en_name: trace_name)
          end
        end
      end
    end
    if trace_products = ProductComponent.where(product_id: new_product.id)
      if trace_product = trace_products.where(ingredient_id: ingredient.id)
        ### already saved as significant ingredient
      else
        ProductComponent.create(
          product_id: new_product.id,
          ingredient_id: ingredient.id,
          amount: 1
        )
      end
    else
      ProductComponent.create(
        product_id: new_product.id,
        ingredient_id: ingredient.id,
        amount: 1
      )
    end

  end
end
