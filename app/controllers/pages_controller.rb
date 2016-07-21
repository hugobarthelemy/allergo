class PagesController < ApplicationController
  skip_after_action :verify_authorized
  def home
    if params[:scanresult]
      @barcode = params[:scanresult]
      if @product = Product.find_by(barcode: @barcode)
        redirect_to product_path(@product)
      else
        @message = "Unknown product. Try again."
      end
    end
  end
end
