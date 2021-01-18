class ApplicationController < ActionController::Base
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def user_not_authorized(e)
    message = e.try(:reason) ? "pundit.errors.#{e.reason}" : e.try(:policy) ? "#{e.policy.class.to_s.underscore}.#{e.query}" : e.message

    flash[:alert] = I18n.t(message, scope: "pundit", default: :default)

    redirect_to(request.referrer || root_path)
  end
end
