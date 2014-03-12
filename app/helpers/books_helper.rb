module BooksHelper
	def lending_ranking
		require 'books_controller'
		BooksController.new._search book_limit:10, sort: { column: "lending_count", sorting: "DESC" } 
	end
	def rep_ranking
		
	end
end
