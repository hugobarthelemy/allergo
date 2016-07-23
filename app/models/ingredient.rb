class Ingredient < ActiveRecord::Base
  has_many :allergy_ingredients, dependent: :destroy
  has_many :product_components

  has_many :allergies, through: :allergy_ingredients

  def self.create_from_api(ingredient_name, lang)
    case lang
    when "fr"
      Ingredient.find_or_create_by(fr_name: ingredient_name)
    when "en"
      Ingredient.find_or_create_by(en_name: ingredient_name)
    when "ja"
      Ingredient.find_or_create_by(ja_name: ingredient_name)
    else
      ### TODO ### "world" name
      Ingredient.find_or_create_by(en_name: ingredient_name)
    end

    # product_component = ProductComponent.new(
    #     ingredient_id: ingredient.id,
    #     product_id: new_product.id,
    #     amount: 2 # 2 for significant amount || ingredient
    #   )

    # product_component.save
  end
end
