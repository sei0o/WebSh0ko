module ApplicationHelper
	def fix_title page_title
		base_title = "Web書庫"
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end
	
	def s2ub str # space to underbar
		str.gsub " ", '_' 
	end
	
	def b2in bol # boolean to int
		bol ? 1 : 0
	end
	
	def caller_method depth = 0
		caller[2 + depth].split(' ')[1].delete('`').delete("'") # caller[2]なのは理由があります: caller[0] -- このメソッドの呼び出しもと
	end
	
	def time2str time
		spt = time.split(/[-T:.]/)
		"#{spt[0]}/#{spt[1]}/#{spt[2]} #{spt[3]}:#{spt[4]}:#{spt[5]}"
	end
	
	def timehash2str timehash
		"#{timehash[:year]}/#{timehash[:month]}/#{timehash[:day]} #{timehash[:hour]}:#{timehash[:minute]}:#{timehash[:second]}"
	end
=begin
	def ocr_scan img
		engine = Tesseract::Engine.new do |engine|
			engine.language = :eng # English
		end
		engine.text_for img
	end
=end
end
