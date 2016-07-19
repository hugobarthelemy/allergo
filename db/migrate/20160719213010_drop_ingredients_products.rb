class DropIngredientsProducts < ActiveRecord::Migration
  def change
    drop_table :ingredients_products
  end
end
