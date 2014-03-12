class User < ActiveRecord::Base
	belongs_to :role
	has_many :lends
	
	before_save { self.email = email.downcase } # 一応
	before_create :set_signin_token # 初期設定
	
	validates :name, presence: true, length: { maximum: 50 }
	validates :account, presence: true, uniqueness: { case_sensitive: false }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, allow_blank: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 10 }
	
	has_secure_password
	
	def to_hash
    ActiveSupport::JSON.decode(self.to_json)
	end
	
	# log in/out 関係
	def User.new_signin_token
		SecureRandom.urlsafe_base64
	end
	
	def User.encrypt token
		Digest::SHA1.hexdigest token.to_s
	end
	
	def role
		Role.find(self.role_id)
	end
	def allowed? permission
		p "YOUR ROLE:#{self.role.name}"
		Role.find_by_sql(["SELECT * FROM roles WHERE name = ? AND `#{permission}` = 1",self.role.name]) != []
	end
	def grant_another_user?
		self.role.grant
	end
	def book_create_allowed?
		self.role.book_create
	end
	def book_read_allowed?
		self.role.book_read
	end
	def book_update_allowed?
		self.role.book_update
	end
	def book_delete_allowed?
		self.role.book_delete
	end
	def book_lend_allowed?
		self.role.book_lend
	end
	def book_return_allowed?
		self.role.book_return
	end
	def user_read_allowed?
		self.role.user_read
	end
	def secret_user_read_allowed?
		self.role.secret_user_read
	end
	def user_update_allowed?
		self.role.user_update
	end
	def user_delete_allowed?
		self.role.user_delete
	end
	def user_follow_allowed?
		self.role.user_follow
	end
	
	private
		
		def set_signin_token
			self.cookie_token = User.encrypt User.new_signin_token
		end
		
end
