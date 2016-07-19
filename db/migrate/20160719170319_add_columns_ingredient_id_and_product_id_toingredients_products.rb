class AddColumnsIngredientIdAndProductIdToingredientsProducts < ActiveRecord::Migration
  def change
    add_reference :ingredients_products, :ingredient, index: true, foreign_key: true
    add_reference :ingredients_products, :product, index: true, foreign_key: true
  end
end
