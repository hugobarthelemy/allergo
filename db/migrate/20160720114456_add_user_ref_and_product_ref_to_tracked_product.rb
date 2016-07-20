class AddUserRefAndProductRefToTrackedProduct < ActiveRecord::Migration
  def change
    add_reference :tracked_products, :user, index: true, foreign_key: true
    add_reference :tracked_products, :product, index: true, foreign_key: true
  end
end
