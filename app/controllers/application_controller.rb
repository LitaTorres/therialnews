class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :age])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :age])
    end

    def after_sign_in_path_for(resource) #si me voy a login, me lleva a las publicaciones
        publications_path
    end

    def authorize_request(kind = nil) #se define este metodo para autorizar una accion x un usuario
        unless kind.include?(current_user.role) || current_user.admin? #Asi el admin tiene acceso a todo
            redirect_to publications_path, notice: " Yo no estas autorizado para esta accion appcontroller"
        end
    end
end


#Linea 16 si se cumple  q el rol del usuario es admin, esta autorizado para hacer la accion  y el codigo no nos redireccione