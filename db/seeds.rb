# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
case Rails.env
when "development"
  # development specific seeding code
  User.destroy_all
  # products and product_components destroyed for test seeding
  # this is not an update of the db!
  Product.destroy_all
  # ProductComponent.destroy_all
  Ingredient.destroy_all ## not destroyed between test seedings ?

  Allergy.destroy_all

  # extract sample products
  search_terms = %w(milk chips chocolat pates) #vous pouvez ajouter des ingrédients

  search_terms.each do |search_term|

    sample_products = Openfoodfacts::Product.search(search_term, locale: 'world').first(5) #nb d'élement seedé

    sample_products.each do |product|
      product.fetch

      Product.create_from_api(product) # creates a product and creates ingredients if new
    end
  end


  # seed des tables d'allergies

  milk_allergy = Allergy.new(name: :milk)
  milk_allergy.save!

  gluten_allergy = Allergy.new(name: :gluten)
  gluten_allergy.save!

  peanuts_allergy = Allergy.new(name: :peanuts)
  peanuts_allergy.save!

  # Definition des allergènes de chaque Allergy

  allergie_ingredient = AllergyIngredient.new(allergy_id: milk_allergy.id)
  allergie_ingredient[:ingredient_id] = Ingredient.where(name: "milk")
  allergie_ingredient.save

  allergie_ingredient = AllergyIngredient.new(allergy_id: gluten_allergy.id)
  allergie_ingredient[:ingredient_id] = Ingredient.where(name: "gluten")
  allergie_ingredient.save

  allergie_ingredient = AllergyIngredient.new(allergy_id: peanuts_allergy.id)
  allergie_ingredient[:ingredient_id] = Ingredient.where(name: "peanuts")
  allergie_ingredient.save

  # création des users

  # Hugo intollerant au lait

  hugo = User.new(email: "hugopoubelle@gmail.com",
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
  hugo.save!
  level = Level.new(
    allergy_level: "1",
    user_id: hugo.id,
    allergy_id: Allergy.where(name: :milk)[0].id)
  level.save!

  # Laurent Garnier => allergique aux cacahuetes
  laurent = User.new(email: "laurent@garnier.com",
    first_name: "Laurent",
    last_name: "Garnier",
    phone_number: "",
    password: "123456",
    email_contact: "laurent@garnier.com",
    picture: "http://www.kdbuzz.com/images/garnier_electrochoc.jpg")
  laurent.save!
  level = Level.new(
    allergy_level: "2",
    user_id: laurent.id,
    allergy_id: Allergy.where(name: :peanuts)[0].id)
  level.save!

  # Laura allergique au lait et intollerante au gluten
  laura = User.new(email: "laura@pedroni.com",
    first_name: "Laura",
    last_name: "Pedroni",
    phone_number: "",
    password: "123456",
    email_contact: "laura@pedroni.com",
    picture: "http://www.kdbuzz.com/images/garnier_electrochoc.jpg")
  laura.save!
  level = Level.new(
    allergy_level: "2",
    user_id: laura.id,
    allergy_id: Allergy.where(name: :milk)[0].id)
  level.save!
  level = Level.new(
    allergy_level: "1",
    user_id: laura.id,
    allergy_id: Allergy.where(name: :gluten)[0].id)
  level.save!

  # Paul intollerant au gluten
  paul = User.new(email: "paul@gaumer.com",
    first_name: "Paul",
    last_name: "Gaumer",
    phone_number: "",
    password: "123456",
    email_contact: "paul@gaumer.com",
    picture: "http://www.kdbuzz.com/images/garnier_electrochoc.jpg")
  paul.save!
  level = Level.new(
    allergy_level: "1",
    user_id: paul.id,
    allergy_id: Allergy.where(name: :gluten)[0].id)
  level.save!

  # Antoine allergique au lait
  antoine = User.new(email: "antoine@reveau.com",
    first_name: "Antoine",
    last_name: "Reveau",
    phone_number: "",
    password: "123456",
    email_contact: "antoine@reveau.com",
    picture: "http://www.kdbuzz.com/images/garnier_electrochoc.jpg")
  antoine.save!
  level = Level.new(
    allergy_level: "2",
    user_id: antoine.id,
    allergy_id: Allergy.where(name: :milk)[0].id)
  level.save!

  # Scanne product # tous les users ont scanné tous les produits
  ScannedProduct.destroy_all

  Product.last(8).each do |product|
    User.last(4).each do |user|
      ScannedProduct.create!(user_id: user.id, product_id: product.id)
    end
  end

  # Tracked product # tous les users track tous les produits
  TrackedProduct.destroy_all

  Product.last(8).each do |product|
    User.last(4).each do |user|
      TrackedProduct.create!(user_id: user.id, product_id: product.id)
    end
  end


  # Reviews # tous les users ont laissé un avis sur chaque produit
  Review.destroy_all

  Product.last(8).each do |product|
    User.last(4).each do |user|
      Review.create!(
        score: [0, 1, 2].sample,
        user_id: user.id,
        product_id: product.id
      )
    end
  end

##############################################################################
##############################################################################
######################### SEED PRODUCTION ####################################
##############################################################################
##############################################################################


when "production"
  laura = User.new(email: "laura@pedroni.com",
    first_name: "Laura",
    last_name: "Pedroni",
    phone_number: "",
    password: "123456",
    email_contact: "laura@pedroni.com",
    picture: "http://www.kdbuzz.com/images/garnier_electrochoc.jpg")
  laura.save!
end
