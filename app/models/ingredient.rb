class Ingredient < ActiveRecord::Base
  has_many :allergy_ingredients, dependent: :destroy
  has_many :product_components

  has_many :allergies, through: :allergy_ingredients

  include AlgoliaSearch

  algoliasearch do
    attribute :fr_name, :en_name

    attributesToIndex ['fr_name', 'en_name']
  end

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
  end


  def any_name
    return self.en_name unless self.en_name.blank?
    return self.fr_name unless self.fr_name.blank?
    return self.ja_name unless self.ja_name.blank?
  end
end
