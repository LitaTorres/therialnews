class UsersController < Devise::ConfirmationsController
   #class UsersController < ApplicationController
    before_action :authorize_admin, only: [:edit_role, :update_role]
    
    def edit_role
        @user = User.find(params[:id])
    end
    
    def update_role
        @user = User.find(params[:id])
        if @user.update(role: params[:user][:role])
        redirect_to users_path, notice: "Rol de usuario actualizado correctamente."
        else
        render :edit_role
        end
    end
    
    private
    
    def authorize_admin
        unless current_user.admin?
        redirect_to publications_path, notice: "No estás autorizado para esto."
        end
    end

    def index
    end

end