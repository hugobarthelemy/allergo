# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


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

    new_product.create
  end

end
