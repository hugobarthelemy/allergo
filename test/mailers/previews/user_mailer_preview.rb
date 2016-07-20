class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first
    product_changed = Product.first
    UserMailer.alert(user, product_changed)
  end
end
