source "https://rubygems.org"
gemspec

gem "rake"
group :development do
  gem "therubyracer", :platforms => :mri, :require => false
  gem "therubyrhino", :platforms => :jruby, :require => false
  gem "stackprof", :platforms => :mri, :require => false
  gem "pry", :require => false
end

group :test do
  gem "codeclimate-test-reporter", :require => false
  gem "rubocop", :github => "bbatsov/rubocop", :branch => :master, :require => false
  gem "luna-rubocop-formatters", :require => false
end

gem "uglifier", :require => false
gem "sprockets-es6", "~> 0.6", :require => false
gem "autoprefixer-rails", "~> 6.0", :require => false
gem "font-awesome-sass", "~> 4.4", :require => false
gem "bootstrap-sass", "~> 3.3", :require => false
gem "mini_magick", "~> 4.2", :require => false
gem "less", "~> 2.6.0", :require => false
