class CreateIngredientsProducts < ActiveRecord::Migration
  def change
    create_table :ingredients_products do |t|
      t.integer :amount

      t.timestamps null: false
    end
  end
end
