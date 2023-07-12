class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :age])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :age])
    end

    def after_sign_in_path_for(resource)
        publications_path
    end

    def authorize_request(kind = nil)
        unless kind.include?(current_user.role)
            redirect_to publications_path, notice: " Yo no estas autorizado para esta accion appcontroller"
        end
    end
end
