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

  sample_products = Openfoodfacts::Product.search(search_term, locale: 'world').last(20)

  sample_products.each do |product|
    product.fetch
    barcode = product.code

    p_name = product.product_name
    # binding.pry
    p_updated_on = product.last_edit_dates_tags.first.to_date

    manufacturer = product.brands
    # manufacturer = product.brands_tags
    # manufacturer = manufacturer.join(',') unless manufacturer.nil?

    categories = product.categories_tags
    categories = categories.join(',') unless categories.nil?

    new_product = Product.new(
      barcode:barcode,
      name: p_name,
      updated_on: p_updated_on,
      manufacturer: manufacturer,
      category: categories
    )

    new_product.save
  end


end
