class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :_create
  
  def create # Sign in
  end

  def _create
    user = User.find_by account: signin_params[:account]
    if user && user.authenticate(signin_params[:password]) # userがいる、そしてパスワードが正しい
      # applicationcontrollerでhelperはインクルードしてます
      sign_in user
      redirect_to user_path(user.account) # issue: フレンドリーフォワーディングは？
    else
      flash.now[:error] = 'アカウント名またはパスワードが違います' # validationはとおしてないよ
      render 'create'
    end
  end

  def _delete # Sign out
    sign_out
    redirect_to root_path
  end
  
  private
    
    def signin_params
      params.require(:session).permit :account, :password
    end
    
end