class CreateTrackedProducts < ActiveRecord::Migration
  def change
    create_table :tracked_products do |t|

      t.timestamps null: false
    end
  end
end
