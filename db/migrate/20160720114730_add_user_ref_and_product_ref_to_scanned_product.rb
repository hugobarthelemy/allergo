class AddUserRefAndProductRefToScannedProduct < ActiveRecord::Migration
  def change
    add_reference :scanned_products, :user, index: true, foreign_key: true
    add_reference :scanned_products, :product, index: true, foreign_key: true
  end
end
