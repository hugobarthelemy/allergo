class Ingredient < ActiveRecord::Base
  has_many :allergy_ingredients, dependent: :destroy
  has_many :product_components

  has_many :allergies, through: :allergy_ingredients

  include AlgoliaSearch

  algoliasearch do
    attribute :fr_name, :en_name

    attributesToIndex ['fr_name', 'en_name']
  end
end
