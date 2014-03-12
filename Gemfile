source 'https://rubygems.org'

ruby '2.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#gem 'rails', '4.1.0.beta1'#,github: 'rails/rails'
#gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'
gem 'rails', '4.0.2'

gem 'bcrypt-ruby', '>= 3.1.2' # has_secure_password
#gem 'tesseract-ocr' # OCRscan

group :development do
	gem 'mysql2'
	#gem 'spring'
	
	# エラー画面をわかりやすく整形してくれる
  gem 'better_errors'

  # better_errorsの画面上にirb/pry(PERL)を表示する
  gem 'binding_of_caller'
end

group :production do
	gem 'pg'
	gem 'rails_12factor'
end

group :doc do
	gem 'sdoc', require: false
end

gem 'sass-rails', '~> 4.0.0' # Sass/SCSS
gem 'uglifier', '>= 1.3.0' # 謎
gem 'coffee-rails', '~> 4.0.0' # CoffeeScript
gem 'json' # APIに使用

gem 'jquery-rails' # jQuery
gem 'turbolinks' # 謎
gem 'jbuilder', '~> 1.2' # 謎

gem 'i18n_generators' # 多言語化

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby


# Use ActiveModel has_secure_password


# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
