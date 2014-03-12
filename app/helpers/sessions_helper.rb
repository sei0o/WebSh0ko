module SessionsHelper
	
	def sign_in user
		sin_token = User.new_signin_token
    cookies[:signin_token] = sin_token
    user.update_attribute :cookie_token, User.encrypt(sin_token)
    self.current_user = user # current_user の切り替え
	end
	
	def sign_out
		self.current_user = nil
		cookies.delete :signin_token
	end
	
	def current_user= user
    @current_user = user
  end
  
  def current_user
    cookie_sintoken = User.encrypt cookies[:signin_token]
    @current_user ||= User.find_by cookie_token: cookie_sintoken
  end
  
  def current_user? user
    user == current_user
  end
  
  def signed_in?
		!current_user.nil?
	end
  
end
