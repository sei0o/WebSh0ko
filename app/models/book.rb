class Book < ActiveRecord::Base
	has_many :lends
	
	validates :title, presence: true, uniqueness: { case_sensitive: false }
#	VALID_DATE_REGEX = /\d{4}\/\d{1,2}\/\d{1,2}/
	#validates :publish, allow_blank:true, format: { with: VALID_DATE_REGEX }
	validates :page, allow_blank:true, numericality: { only_integer: true }
	
	def to_hash
    ActiveSupport::JSON.decode(self.to_json)
	end
	
	def lending?
		lends = Lend.find_by_sql "SELECT id,lending FROM lends WHERE book_id = #{self.id}"
		lends.map! do |lend|
			lend.lending
		end
		lends.include? true
	end
	
	# enum rarity: {normal:0, rare: 1, heavy: 2, super:3, ultra:4}
end