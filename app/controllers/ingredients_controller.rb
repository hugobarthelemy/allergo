class IngredientsController < ApplicationController
  before_action :set_product, only: [:edit, :destroy]
  before_action :set_ingredient, only: [:edit, :destroy]
  skip_after_action :verify_authorized, only: [:destroy]

  def destroy
    product_ingredient = ProductComponent.where(
                            ingredient_id: @ingredient.id,
                            product_id: @product.id,
                            amount: params[:amount]
                          )
    product_ingredient.first.destroy
    redirect_to edit_product_path(@product)

  end

private

  def product_params
    params.require(:product).permit(:barcode, :name, :updated_on, :manufacturer, :category, :img_url, ingredients_attributes: [:id, :iso_reference, :fr_name, :en_name, :ja_name, :_destroy])
  end

  def product_ingredient
    params.require(:ingredient).permit(:ingredient)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end
end
