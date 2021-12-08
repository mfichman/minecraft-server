source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.7.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.0'
# Use pg as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# User management
gem 'devise'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

# Async processing
#gem 'sucker_punch', '~> 2.0'
gem 'sidekiq'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'aws-sdk-s3'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Crypto
gem 'rb-pure25519'

# For job queue and databases
gem 'redis'

gem 'docker-api'
gem 'figaro'
gem 'rubyzip'

# Implicit dependencies required for Alpine Linux
gem 'bigdecimal'
gem 'etc'
gem 'io-console'
gem 'json'
gem 'tzinfo-data'
gem 'webrick'
gem 'irb'

# Permissions
gem 'pundit'

# Digital Ocean server managment
gem 'droplet_kit'

gem 'awesome_print'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  #gem 'guard-livereload', '~> 2.5', require: false
  #gem 'rack-livereload'
  #gem 'wdm', '>= 0.1.0' if Gem.win_platform?
  #gem 'eventmachine'
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

