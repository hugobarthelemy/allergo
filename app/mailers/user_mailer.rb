class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.alert.subject
  #
  def alert_admins_change(product_changed_id, ingredient_id, action)

    @greeting = "Hi"
    @product_changed = Product.find(product_changed_id)
    @changed_ingredients_name = Ingredient.find(ingredient_id).any_name
    @action = action

    @destination_email = "barthelemyhugo@gmail.com"
    @destination_email_two = "antoinerev@gmail.com"
    @user_name = "Hugo Barthelemy"
    # @user_name = "#{@user.first_name} #{@user.last_name}"

    mail(to: @destination_email, subject: 'Product Change Alert')

    @user_name = "Antoine Reveau"
    mail(to: @destination_email_two, subject: 'Product Change Alert')
    # This will render a view in `app/views/user_mailer`!
  end


  def alert(user_id, product_changed_id, added_ingredients=[])

    @greeting = "Hi"
    @product_changed = Product.find(product_changed_id)
    @added_ingredients = added_ingredients

    @user = User.find(user_id)  # Instance variable => available in view
    @user_name = "#{@user.first_name} #{@user.last_name}"

    mail(to: @user.email, subject: 'Product Change Alert')
    # This will render a view in `app/views/user_mailer`!
  end
end
