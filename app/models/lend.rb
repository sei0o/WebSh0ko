class Lend < ActiveRecord::Base
	belongs_to :book
	belongs_to :user
	
	def to_hash
    ActiveSupport::JSON.decode(self.to_json)
	end
	
end
