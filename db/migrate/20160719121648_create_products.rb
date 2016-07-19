class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :barcode
      t.string :name
      t.date :updated_on
      t.string :manufacturer
      t.string :category

      t.timestamps null: false
    end
  end
end
