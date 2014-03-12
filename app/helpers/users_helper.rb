module UsersHelper
	def anonymous_user
		anonymous_role_id = Role.find_by(name: "anonymous").id
		User.new(role_id: anonymous_role_id)
	end
end