


Product.destroy_all

# extract products

search_terms = %w(chocolat chips creme fromage soupe)

search_terms.each do |search_term|

  sample_products = Openfoodfacts::Product.search("chocolat", locale: 'world').sample(20)

  sample_products.each do |product|
    barecode = product.code
    p_name = product.product_name
    p_updated_on = product.product_t
    manufacturer = product.brands
    category = product.categories_tags

    new_product = Product.new(
      barecode:barecode,
      name: p_name,
      updated_on: updated_on,
      manufacturer: manufacturer,
      category: category
    )

    new_product.save
  end

end

# barecode = Openfoodfacts::Product.get(code, locale: 'world').code
# p_name = Openfoodfacts::Product.get(code, locale: 'world').product_name
# p_updated_on = Openfoodfacts::Product.get(code, locale: 'world').last_modified_t
# manufacturer = Openfoodfacts::Product.get(code, locale: 'world').brands
# category = Openfoodfacts::Product.get(code, locale: 'world').categories_tags
# language = Openfoodfacts::Product.get(code, locale: 'world').lang
# purchase_places = Openfoodfacts::Product.get(code, locale: 'world').purchase_places



# Openfoodfacts::Product.get(code, locale: 'world').ingredients_text_en

# 0009800801107 => nutella mini cups
#
# quantity: "10 MINI CUPS - 5.2 OZ (150 g)",
# packaging: "Box",

# ingredients_text_fr

# ingredients_text_with_allergens_fr
# "Semoule de maïs 59%, <span class="allergen">arachides</span> grillées moulues, huile de tournesol 9%, sel, base aromatisante épice (arôme naturel, tomate)."


# last_modified_t 1442771683
# last_edit_dates_tags:  [
# "2015-12-26",
# "2015-12",
# "2015"

# entry_dates_tags: [
# "2015-07-26",
# "2015-07",
# "2015"


# image_thumb_url "http://static.openfoodfacts.org/images/products/333/697/071/1064/front_fr.3.100.jpg"
# image_ingredients_url "http://static.openfoodfacts.org/images/products/333/697/071/1064/ingredients_fr.6.400.jpg"

# ingredients: [
# {
# text: "SUGAR",
# id: "sugar",
# rank: 1
# },
# {
# text: "PALM OIL",
# id: "palm-oil",
# rank: 2
# },


# ingredients_tags:
# "sugar",
# "palm-oil",
# "hazelnuts",
# "cocoa",
# "skim-milk",
# "reduced-minerals-whey",
# "milk",
# "lecithin-as-emulsifier",
# "soy",
# "vanillin",
# "an-artificial-flavor"

# allergens
# allergens_tags: [
# "en:milk",
# "en:nuts",
# "en:soybeans"

# traces_tags: [
# "en:crustaceans",
# "en:eggs",
# "en:fish",
# "en:molluscs",
# "en:mustard",
# "en:peanuts",
# "en:sesame-seeds",
# "en:soybeans"
# ],

# traces_tags
# traces "Lait"
# traces_hierarchy "en:milk"
# traces_tags "en:milk"
# product_name_fr

# categories


# lang

# purchase_places
# countries
# countries_tags "en:france"

# manufacturing_places_tags: [
# "germany"
# manufacturing_places: "Germany",

# brands_tags: "nutella", "ferrero"
# brands: "Nutella,Ferrero",


# code
# _id
