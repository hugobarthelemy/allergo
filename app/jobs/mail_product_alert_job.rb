class MailProductAlertJob < ActiveJob::Base
  queue_as :default

  def perform(product_changed_id)
    # Do something later
    products_tracked = TrackedProduct.where(product_id: product_changed_id)

    products_tracked.each do |product_tracked|
      user_id = product_tracked.user_id

      UserMailer.alert(user_id, product_changed_id).deliver_later
      puts "MAIL SENT!"
    end
  end
end
