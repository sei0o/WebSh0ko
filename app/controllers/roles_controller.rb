class RolesController < ApplicationController
  
  def create
  end

  def show
  end

  def edit
  end

  def delete
  end

  def authorization
    @user = User.find_by account: params[:account]
    @roles = Role.all
    roles_hash = {}
    @roles.each do |role|
      roles_hash[role.name] = role.id
    end
    @roles = roles_hash
    @role = Role.find @user.role_id
  end

  #
  # ここから処理
  #
  
  def _authorization
    user = User.find_by account: params[:account]
    if user.update_attribute(:role_id, role_params[:id])
      flash[:success] = "権限の変更が完了しました。"
      redirect_to user_path(user.account)
    else
      #render 'authorization'
      redirect_to user_auth_path
    end
  end
  
  private
  
    def role_params
      params.require(:role).permit :id
    end
  
end
