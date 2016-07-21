class RenameAllergiesIngredientsToAllergyIngredients < ActiveRecord::Migration
  def change
    rename_table("allergies_ingredients", "allergy_ingredients")
  end
end
