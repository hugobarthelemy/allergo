class AddImgUrlToProduct < ActiveRecord::Migration
  def change
    add_column :products, :img_url, :string
  end
end
