class BooksController < ApplicationController
	helper_method :search
	helper_method :_search
	helper_method :_lend_now_limit
	# API用。脆弱性なのかな？
	skip_before_filter :verify_authenticity_token, only: [ :_lend, :_return, :_search, :_show ] 
	BOOK_LEND_LIMIT = 3.weeks
	
	def lend
	end
		
	def return
	end
	
	def show
		@book = _show show_params[:id]
	end
	
	def search
		search_params[:title] = URI.decode search_params[:title].to_s # param
		@search_word = search_params[:title]
		@books = _search search_params
	end
	
	def index
		@books = _search sort: { column: "created_at", sorting: "DESC" }
	end
	
	def create
		@book = Book.new params[:book]
	end
	
	def edit
		@book = Book.find_by show_params[:id]
	end
	
	def delete
	end
	#
	# ここからAPI
	#
	
	def _show book_id = show_params[:id]
		# データ取得
		book = Book.find book_id
		# データ整形・追加 
		book = book.to_hash # Hashにする
		book = book.symbolize_keys # キーをシンボルに
		# 	日付整形
		if book[:publish]
			pub_sp = book[:publish].split "-" 
			book[:publish] = { year: pub_sp[0], month: pub_sp[1], day: pub_sp[2] }
		end
		pub_sp = book[:created_at].split(/[-T:.]/)
		book[:created_at] = { year: pub_sp[0], month: pub_sp[1], day: pub_sp[2] }
		#		bookの貸出情報(過去含む)
		lend = Lend.find_by_sql "SELECT * FROM lends WHERE book_id = #{book[:id]}"
		unless lend.blank?
			#		Lend -> Array(Hashを含む)
			lend_arr = []
			lend = lend.each do |record|
				lend_arr << record.to_hash.symbolize_keys
			end
			lend = lend_arr # lendがLendのインスタンスからArrayに生まれ変わる
			
			#	  貸出回数取得
			book[:lending_count] = lend.size
			#		最終貸出日
			ll_sp = lend.last[:created_at].split(/[-T:.]/) # -T:.で分割
			book[:last_lending] = { year: ll_sp[0], month: ll_sp[1], day: ll_sp[2], hour: ll_sp[3], minute: ll_sp[4], second: ll_sp[5] }
			
			#		貸出中?
			now_lending = {}
			lend.each do |val| # 注意: valにはHashがはいります
				if val[:lending]
					now_lending = val
					break
				end
			end
			if now_lending.any?
				book[:lending] = true
				limit_sp = now_lending[:limit].split "-"
				book[:lending_limit] = { year: limit_sp[0], month: limit_sp[1], day: limit_sp[2] }
			else
				book[:lending] = false
			end
		end
		
		# Debug
		p book
		p lend
		p now_lending
		
		# Viewを通したアクセスならばハッシュのままで返す
		params[:action] == "show" ? book : (render json: { data: book })
	end
	
	def _search ops = search_params # API
		# 1.lendsテーブルからlending=1のテーブルを探す。
		# 2.そのなかから、booksのidとbook_idが等しいもの(関連づいているもの)を探す。
=begin
		絞り込み検索(情報を付加しないのでSQLで直接)
		 - id
		 - title
		 - publish
		 - page (いるかなぁ？)
		 - shelf(_id)
		 - category(_id
		 - rarity
		 - created_at(追加日)
		 - updated_at(変更日/いるかなぁ？)
		 - writer
		 
		 - lending
		 - limit
		 - user_id
		 
		 - sort
		 - book_limit
=end
		# パラメータを追加
		query = []
		order = []
		if ops
			if ops[:id]
				query << "id = #{ops[:id]}"
			end
			if ops[:title]
				query << "title LIKE \"%#{ops[:title]}%\""
			end
			if ops[:publish] # 範囲
				query << "publish = #{ops[:publish]}"
			end
			if ops[:page_min] && ops[:page_max] # 範囲いるかなぁ？
				query << "page BETWEEN #{ops[:page_min] || 0} AND #{ops[:page_max] || 999999999999999999999999}"
			end
			if ops[:shelf_id]
				query << "shelf_id = #{ops[:shelf_id]}"
			end
			if ops[:category_id]
				query << "category_id = #{ops[:category_id]}"
			end
			if ops[:rarity]
				query << "rarity = #{ops[:rarity]}"
			end
			if ops[:created_at_start] || ops[:created_at_end] 
				query << "created_at BETWEEN #{ops[:created_at_start] || Time.now.to_s(:db)} AND #{ops[:created_at_end] || Time.now.to_s(:db)}"
			end
			if ops[:updated_at_start] || ops[:updated_at_end] 
				query << "updated_at BETWEEN #{ops[:updated_at_start] || Time.now.to_s(:db)} AND #{ops[:updated_at_end] || Time.now.to_s(:db)}"
			end
			if ops[:writer]
				query << "writer = \"#{ops[:writer]}\""
			end
			unless ops[:lending].nil?
				if ops[:lending]
					query << "EXISTS(SELECT id FROM lends WHERE book_id = books.id AND lending = 1)"
				else
					query << "NOT EXISTS(SELECT id FROM lends WHERE book_id = books.id AND lending = 1)"
				end
			end
			if ops[:limit_start] || ops[:limit_end]
				query << "EXISTS(SELECT id FROM lends WHERE book_id = books.id AND limit BETWEEN #{ops[:limit_start] || Time.now.to_s(:db)} AND #{ops[:limit_start] || Time.now.to_s(:db)})"
			end
			if ops[:user_id]
				query << "EXISTS(SELECT id FROM lends WHERE book_id = books.id AND user_id = #{ops[:user_id]})"
			end
			
			if ops[:sort] # ASC or DESC
				if ops[:sort][:column] == "lending_count"
					ops[:sort][:column] = "(SELECT count(*) FROM lends WHERE book_id = books.id)"
				end
				
				order << "#{ops[:sort][:column]} #{ops[:sort][:sorting]}"
			end
			
			if ops[:book_limit] # ランキングとか
				$limit = ops[:book_limit]
			end
			
		end
		query = query.join " AND "
		order = order.join " AND "
		books = (Book.find_by_sql <<-EOQ)
			SELECT *
			FROM books
			#{"WHERE" unless query == ""} #{query}
			#{"ORDER BY " unless order == ""} #{order}
			#{"LIMIT #{$limit}" unless $limit.nil? }
		EOQ
		p books
		p "HHAAHHHHAHH"
		p ops
		
		books
		#params[:action] == nil ? (render json: { data: books } ) : books
	end
	
	def _lend book_title = lend_params[:title]
		# Book の idを取得
		unless Book.find_by(title: book_title).blank?
			book = Book.find_by(title: book_title)
			# _search の方でフィルタ済み
			p "BOOK.LENDS #{book.lends}"
			#if book.lends.find_by(book_id: book.id).lending # 既に貸出中？
			#	flash[:error] = "既に貸出中です。"
			#end
			
			# Lend の インスタンスを生成
			blimit = _lend_now_limit
			uid = signed_in? ? current_user.id : 0
			lend = Lend.new lending: true, book_id: book.id, user_id: uid, limit: (blimit.to_s :db)
			if lend.save
				# 保存成功
				flash[:success] = "「#{book.title}」を貸し出しました。#{blimit.strftime "%Y/%m/%d"}までに返してください。"
			else
				# 保存失敗
				flash[:error] = "保存に失敗しました。"
			end
		else
			# 本が見つからない
			flash[:error] = "本が見つかりません"
		end
		if ret_route flash[:error], false # 三項演算子で書けないなっしー！
			redirect_to book_lend_path
		else
			render json: { error: flash[:error] }
		end
	end
	
	def _return
		unless Book.find_by(title: lend_params[:title]).blank?
			# Book の id を取得
			p lend_params[:title]
			book = Book.find_by(title: lend_params[:title])
			# Lendを取得
			if Lend.find_by_sql "SELECT * FROM lends WHERE book_id = #{book.id} AND lending = 1"
				lend = Lend.find_by_sql("SELECT * FROM lends WHERE book_id = #{book.id} AND lending = 1 LIMIT 1")[0]
				if lend.lending == true # まだ返していない
					lend.lending = false
					if lend.save
						# 保存成功
						#nokori_lend = Lend.find_by_sql "SELECT count(*) FROM lends WHERE user_id = #{}"
						flash[:success] = "「#{book.title}」を返却しました。経験値nUP! あとn冊"
					else
						# 保存失敗
						flash[:error] = "保存に失敗しました。"
					end
				else # もう返した
					flash[:error] = "その本はもう返しました"
				end
			else # そもそも借りていない
				flash[:error] = "その本は借りていません"
			end
		else # 本がない
			flash[:error] = "本が見つかりません"
		end
		if ret_route flash[:error], false # 三項演算子で書けないなっしー！
			redirect_to book_return_path
		else
			render json: { error: flash[:error] }
		end
	end
	
	def _create
		@book = Book.new book_params
		if @book.save
			# 保存成功
			flash[:success] = "本の登録が完了しました。"
      redirect_to book_path @book
		else
			render 'create'
		end
	end
	
	def _edit
		@book = Book.find_by show_params[:id]
		if @book.update_attributes book_params
			flash[:success] = "編集完了！"
			redirect_to book_path(@book)
		else
			render 'edit'
		end
	end
	
	def _delete
		book = Book.find show_params[:id]
		if book.destroy && Lend.destroy_all(book_id: book.id) # その本自体の貸出情報も削除
			flash[:success] = "削除完了！"
			redirect_to root_path
		else
			flash[:error] = "削除に失敗しました。"
			redirect_to book_path(book[:id]) 
		end
	end
	
	def _lend_now_limit
		Time.now + BOOK_LEND_LIMIT
	end
	
	private
	
		def search_params
		  params.permit :raction, :id, :title, :sort, :category, :shelf
		end
		
		def lend_params
			params.permit :title
		end
		
		def show_params
			params.permit :id
		end
		
		def book_params
			params.require(:book).permit :title, :page, :publish, :category_id, :rarity, :shelf_id, :writer
		end
		
		def ret_route ret, render_for = true
			# 内部からのアクセス？
			if params[:controller] == ( "books" || "fixed_pages" || "users" || "settings" )
				true
			else
				render json: { data: ret } if render_for
				false
			end
		end

end