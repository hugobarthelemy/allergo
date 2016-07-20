class ProductComponent < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :product
end
