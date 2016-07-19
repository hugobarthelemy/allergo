class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :iso_reference
      t.string :fr_name
      t.string :en_name
      t.string :ja_name

      t.timestamps null: false
    end
  end
end
