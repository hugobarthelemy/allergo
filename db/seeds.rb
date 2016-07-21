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
milk_allergy = Allergy.new(name: :milk)
milk_allergy.save

gluten_allergy = Allergy.new(name: :gluten)
gluten_allergy.save

peanuts_allergy = Allergy.new(name: :peanuts)
peanuts_allergy.save

# Definition des allergènes de chaque Allergy

allergie_ingredient = AllergyIngredient.new(allergy_id: milk_allergy.id)
allergie_ingredient[:ingredient_id] = Ingredient.where(name: "milk")
allergie_ingredient.save

# création des users

User.destroy_all
user = User.new(email: "hugopoubelle@gmail.com",
  first_name: "Hugo",
  last_name: "Barthelemy",
  phone_number: "0676595703",
  email_contact: "bidule@gmail.com",
  provider: "facebook",
  password: "123456",
  uid: "10154325945005902",
  picture: "http://graph.facebook.com/10154325945005902/picture?type=large",
  token: "EAAM77PGixRIBAHTBcIr4Jqy8rE6RZAhxcVUS8YkJ9JLYHt7AK7OKHUUZCEUZBCYgBjR0ifuA29nLH3VtEYEUoZBnGTjfgOTbIJk8AsZAmyDU42BZBZCAvZB75fCAagmPE2WFiHto6ki6qs4t1Tz1YxNzisUObZA422YYZD",
  token_expiry: "2016-09-17 17:55:37")
user.save!
level = Level.new(
  allergy_level: "2",
  user_id: user.id,
  allergy_id: Allergy.where(name: :milk)[0].id)
level.save!
user = User.new(email: "laurent@garnier.com",
  first_name: "Laurent",
  last_name: "Garnier",
  phone_number: "",
  password: "123456",
  email_contact: "Laurent@garnier.com",
  picture: "http://www.kdbuzz.com/images/garnier_electrochoc.jpg")
user.save!
level = Level.new(
  allergy_level: "1",
  user_id: user.id,
  allergy_id: Allergy.where(name: :milk)[0].id)
level.save!





