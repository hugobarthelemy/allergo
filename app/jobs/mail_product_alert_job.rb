class MailProductAlertJob < ActiveJob::Base
  queue_as :default

  def perform(product_changed)
    # Do something later
    products_tracked = TrackedProduct.where(product_id: product_changed.id)

    products_tracked.each do |product_tracked|
      user = User.find(product_tracked.user_id)

      UserMailer.alert(user, product_changed).deliver_now
    end
  end
end
