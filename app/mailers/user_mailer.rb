class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.alert.subject
  #
  def alert
    @greeting = "Hi"
    @products_changed ################ TODO

    @user = user  # Instance variable => available in view
    @user_name = "@user.first_name @user.last_name"

    mail(to: @user.email, subject: 'Product Change Alert')
    # This will render a view in `app/views/user_mailer`!
  end
end
