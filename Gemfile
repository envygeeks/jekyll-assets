source "https://rubygems.org"
gemspec

gem "rake"
group :development do
  gem "mini_racer", platforms: :mri, require: false
  gem "therubyrhino", platforms: :jruby, require: false
  gem "stackprof", platforms: :mri, require: false
  gem "pry", require: false
end

group :test do
  gem "codeclimate-test-reporter", require: false
  gem "rubocop", require: false
end

gem "uglifier", require: false
gem "autoprefixer-rails", require: false
gem "sprockets", "#{ENV["SPROCKETS_VERSION"] || "~> 4.0.beta"}"
gem "jekyll", "#{ENV["JEKYLL_VERSION"]}" if ENV["JEKYLL_VERSION"]
gem "font-awesome-sass", "~> 4.4", require: false
gem "mini_magick", "~> 4.2", require: false
gem "image_optim", "~> 0.25", require: false
gem "image_optim_pack", "~> 0.5", require: false
gem "less", "~> 2.6.0", require: false
gem "babel-transpiler", require: false
gem "bootstrap", require: false
