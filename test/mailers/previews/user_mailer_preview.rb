class UserMailerPreview < ActionMailer::Preview
  def alert_admins_change
    @product_changed_id = Product.last.id
    @ingredient_id = Ingredient.last.id
    @action = "added"
  end
end
