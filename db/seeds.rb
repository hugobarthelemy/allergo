# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# products and product_components destroyed for test seeding
# this is not an update of the db!
Product.destroy_all
# ProductComponent.destroy_all
Ingredient.destroy_all ## not destroyed between test seedings ?

# extract sample products
search_terms = %w(milk chocolat) #vous pouvez ajouter des ingrédients

search_terms.each do |search_term|

  sample_products = Openfoodfacts::Product.search(search_term, locale: 'world').first(5) #nb d'élement seedé

  sample_products.each do |product|
    product.fetch

    Product.create_from_api(product) # creates a product and creates ingredients if new
    end
  end

# seed des tables d'allergies
Allergy.destroy_all
allergy = Allergy.new(name: :milk)
allergy.save
allergie_ingredient = AllergyIngredient.new(allergy_id: Allergy.last.id)
allergie_ingredient[:ingredient_id] = Ingredient.where(name: "milk")
allergie_ingredient.save



