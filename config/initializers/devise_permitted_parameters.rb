module DevisePermittedParameters
  extend ActiveSupport::Concern

  included do
    before_action :configure_permitted_parameters, if: :devise_controller?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:photo, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:photo, :first_name, :last_name])
  end
end

Rails.application.config.to_prepare do
  DeviseController.include DevisePermittedParameters
end
