source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# for design
gem 'bootstrap3-rails'
gem 'bootstrap-material-design'
gem 'slim-rails'

gem 'devise'
gem 'omniauth-twitter' # => Twitterログイン

# タスク
gem 'rake'        # => rakeタスクを定期実行して勉強ログを取る


# for API
gem 'jbuilder', '~> 2.0'
gem 'yajl-ruby' # for jbuilder. faster background

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'quiet_assets'        # => assetsのログを消す
  gem 'better_errors'       # 開発中のエラー画面をリッチにする
  gem 'binding_of_caller'   # 開発中のエラー画面にさらに変数の値を表示する
  gem 'rails-erd'           # => モデルのER図を作ってくれる
  #gem 'rack-mini-profiler'  # => レスポンス速度, sql発行を確認 
  gem 'byebug'
  gem 'sqlite3'
end

group :development do
  gem 'web-console', '~> 3.0'
  gem "bullet"      # => N+1問題検出
  gem 'spring'      # => 立ち上がりを早く
  gem 'pry'         # => irb上位互換インタプリタ
  gem 'pry-doc'     # => pry上からmethod等のソースコードを確認可能に．
  gem 'pry-coolline' # => pryの入力に対してハイライト
  gem 'hirb'
  gem 'hirb-unicode'  # 2byte文字で表示がずれるのを改善してくれる
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

