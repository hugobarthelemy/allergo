class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  include Pundit

  after_action :verify_authorized, except: [:index, :search], unless: :devise_controller? #on one element
  after_action :verify_policy_scoped, only: [:index, :search], unless: :devise_controller? #on a collection

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(pages_home_path)
  end

  def default_url_options
  { host: ENV['HOST'] || 'localhost:3000' }
  end

end
