source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.3'
# Use sqlite3 as the database for Active Record
# Use Puma as the app server
gem 'api-ai-ruby', '~> 2.1'
gem 'faraday', '~> 0.9.2'
gem 'fcm', '~> 0.0.2'
gem 'puma', '~> 3.7'
gem 'rubocop'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'sqlite3', '~> 1.3', '>= 1.3.11'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'mysql2'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
