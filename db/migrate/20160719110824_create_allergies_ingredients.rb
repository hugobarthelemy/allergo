class CreateAllergiesIngredients < ActiveRecord::Migration
  def change
    create_table :allergies_ingredients do |t|
      t.references :ingredient, index: true, foreign_key: true
      t.references :allergy, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
