class UsersController < ApplicationController
	REQUIRE_PERMISSIONS = { edit: "user_update", _edit: "user_update", _delete: "user_delete" }
	skip_before_filter :verify_authenticity_token, only: [ :_search, :_show ]
  before_filter do |c| # 権限が付与されたユーザー？
		# REQUIRE_PERMISSIONSの中になかったら権限はいらないということ
		ok_user REQUIRE_PERMISSIONS[params[:action].intern] unless REQUIRE_PERMISSIONS[params[:action].intern].nil?
	end
	
	def create # C 
		@user = User.new params[:user]
	end
	
	def show # R
		require 'books_controller'
		@user = _show show_params[:account]
		
		lend_hist_ids = @user[:lend_history].uniq
		@lending_books = []
		lend_hist_ids.each do |book_id|
			@lending_books << BooksController.new._search( id: book_id )[0]
		end
		
		@favorite_book = BooksController.new._search( id: @user[:favorite_book_id] )[0]
		#now_lending_ids ( near lending_books)
		
		now_lending_books = @user[:now_lending_book_id].uniq
		@now_lending_books = []
		now_lending_books.each do |book_id|
			@now_lending_books << BooksController.new._search( id: book_id )[0]
		end
		
		p @lending_books
		p @now_lending_books
	end
	
	def index # R_A
		@users = User.all
	end
	
	def edit # U
		@user = User.find_by account: show_params[:account]
	end
	
	def search # S
		
	end
	
	def icon
		@user = User.find_by account: show_params[:account]
		send_data @user.icon, type: @user.icon_type, disposition: :inline
	end
	
	#
	# ここからAPI
	#
	
	def _create # C
		@user = User.new user_params
		unless user_params[:icon].nil? 
			@user.icon = user_params[:icon].read # バイナリセット
			@user.icon_type = user_params[:icon].content_type
		end
		if @user.save
			# 保存成功
			flash[:success] = "ユーザー登録成功!"
			sign_in @user
			redirect_to root_path
		else
			# 保存失敗
			render 'create'
		end
	end
	
	def _show user_name = show_params[:account] # R
=begin
	変数説明
	user: ユーザーデータ
	lends: userが貸し出した本の配列
=end
		# userデータ取得
		user = User.find_by(account: user_name)
		# データ追加・整形
		user = user.to_hash.symbolize_keys # Hashにする
		#		プライベート項目を削除 (class_idも消すべき？)
		user.delete :email
		user.delete :password_digest
		#		時刻系データ変換 ( created_at, updated_at )
		cr_sp = user[:created_at].split(/[-T:.]/) # -T:.で分割
		user[:created_at] = { year: cr_sp[0], month: cr_sp[1], day: cr_sp[2], hour: cr_sp[3], minute: cr_sp[4], second: cr_sp[5] }
		up_sp = user[:updated_at].split(/[-T:.]/) # -T:.で分割
		user[:updated_at] = { year: up_sp[0], month: up_sp[1], day: up_sp[2], hour: up_sp[3], minute: up_sp[4], second: up_sp[5] }
		#		RBACに対応
		user[:role] = Role.find(user[:role_id]).name
		# 	本とユーザーの関係に関する情報
		lends = Lend.find_by_sql "SELECT * FROM lends WHERE user_id = #{user[:id]}"
		# 		LendインスタンスArrayから普通のArrayに
		lends_arr = []
		lends.each do |record| # recordはLendインスタンス
			lends_arr << record.to_hash.symbolize_keys
		end
		lends = lends_arr
		# 		最近借りた本
		user[:lend_history] = lends.collect do |lend|
			lend[:book_id]
		end
		#			貸出回数
		user[:lending_count] = lends.size
		#			お気に入りの本・シリーズ(最も借りている本)
		fabook = lends.collect do |lend|
			lend[:book_id]
		end
		p fabook
		fabook = fabook.max_by do |book| # ブロックの中でいちばん大きい返り値のvalueをfabookに代入(fabookは最も借りた本のID)
			# |book|の貸出回数を返す
			fabook.count book
		end
		lends.each do |lend|
			if lend[:book_id] == fabook
				# 本のIDを取得
				user[:favorite_book_id] = fabook
			end
		end
		#			今読んでいる本
		user[:now_lending_book_id] = []
		lends.each do |lend|
			if lend[:lending]
				user[:now_lending_book_id] << lend[:book_id] 
			end
		end
		#			貸出期限を過ぎた本
		user[:lending_deadline_past_book_id] = []
		lends.each do |lend|
			if Date.strptime(lend[:limit], "%Y-%m-%d") < Date.today && lend[:lending] == true
				user[:lending_deadline_past_book_id] << lend[:book_id]
			end
		end
		
		#		ユーザーそのもの
		# 		経験値・レベル(パ○ドラにのっとってランクでもいいかな)
		
		# Debug
		p user
		p lends
		p fabook
		p params.class
		
		params[:action] == "show" ? user : (render json: { data: user })
	end
	
	def _index # R_A
		
	end
	
	def _edit # U
		@user = User.find_by(account: user_params[:account])
		if @user.update_attributes user_params
			flash[:success] = "編集完了！"
			redirect_to user_path(@user.account)
		else
			render 'edit'
		end
	end
	
	def _delete # D
		user = User.find_by account: show_params[:account]
		if user.destroy && Lend.destroy_all(user_id: user.id) # その人の貸出履歴も削除
			flash[:success] = "削除完了! ＿やりなおす＿"
			redirect_to root_path
		else
			flash[:error] = "削除に失敗しました。"
			redirect_to user_path(user.account) 
		end
	end
	
	def _search # S
		
	end
	
	private
		
		def user_params
			params.require(:user).permit :name, :account, :email, :password, :password_confirmation, :bio, :icon, :icon_type
		end
		
		def show_params
			params.permit :account
		end
		
    def ok_user require_permission
			if signed_in?
				# 例えば :account/edit なら、 :accountのユーザーか、user_update権限を付与されたユーザーを通す
				user = User.find_by account: params[:account]
				
				unless current_user?(user) || current_user.allowed?(require_permission)
					redirect_to root_path
				end
			else
				unless anonymous_user.allowed? require_permission
					redirect_to root_path
				end
			end
		end
    
end
