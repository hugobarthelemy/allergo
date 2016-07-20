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
ProductComponent.destroy_all
# Ingredient.destroy_all ## not destroyed between test seedings

# extract sample products
search_terms = %w(chocolat chips creme fromage soupe)

search_terms.each do |search_term|

  sample_products = Openfoodfacts::Product.search(search_term, locale: 'world').last(5)

  sample_products.each do |product|
    product.fetch
    barcode = product.code

    p_name = product.product_name
    p_updated_on = product.last_edit_dates_tags.first.to_date

    manufacturer = product.brands
    # manufacturer = product.brands_tags
    # manufacturer = manufacturer.join(',') unless manufacturer.nil?

    categories = product.categories_tags
    categories = categories.join(',') unless categories.nil?

    p_ingredients = product.ingredients

    # languages_hierarchy

    new_product = Product.new(
      barcode:barcode,
      name: p_name,
      updated_on: p_updated_on,
      manufacturer: manufacturer,
      category: categories
    )

    new_product.save

    # ingredients seeding from products
    # binding.pry
    p_ingredients.each do |p_ingredient|
      if ingredient = Ingredient.find_by(en_name: p_ingredient.id)
      else
        ingredient = Ingredient.new(
          # iso_reference: ,
          # fr_name: ,
          # ja_name:,
          en_name: p_ingredient.id
        )

        ingredient.save
      end

      product_component = ProductComponent.new(
          ingredient_id: ingredient.id,
          product_id: new_product.id,
          amount: 2 # 2 for significant amount || ingredient
        )

      product_component.save
    end

  end


end
