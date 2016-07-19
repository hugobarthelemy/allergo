class CreateScannedProducts < ActiveRecord::Migration
  def change
    create_table :scanned_products do |t|

      t.timestamps null: false
    end
  end
end
