require 'json'
require 'open-uri'

namespace :update_db_from_api do

  desc "Check Open Food Fact API for updates"
  task :check_api => :environment do
    last_updated_date = Product.all.order('updated_on DESC').first.updated_on.strftime(format='%Y-%m-%d')
    date_today = Date.today.strftime(format='%Y-%m-%d')

    api_url = "https://openfoodfacts-api.herokuapp.com/products?"
    api_url_search = "#{api_url}last_edit_dates_tags="

    recent_edited_products = []

    (last_updated_date..date_today).each do |day|
      open("api_url_search#{day}") do |stream|
        recent_edited_products << JSON.parse(stream.read)

      end
    end

    recent_edited_products.each do |api_product|
      if product_in_db = Product.find_by(barcode: api_product.code)
        ingredients_to_compare = api_product.ingredients.id
        suppressed_ingredients = []

        case api_product.lc
        when "fr"
          product_in_db.ingredients.each do |db_ingredient|
            if ingredients_to_compare.include(db_ingredient.fr_name)
              ingredients_to_compare.pop(db_ingredient.fr_name)
            else
              ingredients_to_compare == []
              suppressed_ingredients << db_ingredient
            end
          end
        when "en"
          product_in_db.ingredients.each do |db_ingredient|
            if ingredients_to_compare.include(db_ingredient.en_name)
              ingredients_to_compare.pop(db_ingredient.en_name)
            else
              ingredients_to_compare == []
              suppressed_ingredients << db_ingredient
            end
          end
        when "ja"
          product_in_db.ingredients.each do |db_ingredient|
            if ingredients_to_compare.include(db_ingredient.ja_name)
              ingredients_to_compare.pop(db_ingredient.ja_name)
            else
              ingredients_to_compare == []
              suppressed_ingredients << db_ingredient
            end
          end
        else
        end
        if ingredients_to_compare.first
          added_ingredients = ingredients_to_compare
          MailProductAlertJob.perform_later(product_in_db.id, added_ingredients)
        end
      else
        new_product = Product.new()

      end

    end


  end

  desc "Task description"
  task task_name: [:prerequisite_task, :another_task_we_depend_on] do
    # All your magic here
    # Any valid Ruby code is allowed

  end

end

### TODO ###
# check produit updatés dans OFF

# comparer produits existants avec 2 array

# pour ingredients ajoutés =>
#      voir utilisateurs qui trackent
#      envoyer mail
#      option : verifier si ingredient correspond à l’allergie de l'user

#      ajouter à la newsboard/newsletter des allergiques à l’ingredient même si pas tracking

# pour ingredient supprimé =>
#      ajouter à la newsboard/newsletter des allergiques à l’ingredient même si pas tracking

# dashboard/newsboard generale avec les modifs
