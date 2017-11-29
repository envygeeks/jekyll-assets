# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

source "https://rubygems.org"
gemspec

sv = "~> 4.0.beta"
gem "sprockets", ENV["SPROCKETS_VERSION"] || sv, require: false
gem "jekyll", ENV["JEKYLL_VERSION"], require: false if ENV["JEKYLL_VERSION"]
gem "rake", require: false

# --
group :development do
  gem "travis", require: false
  gem "mini_racer", require: false if RUBY_PLATFORM != "java"
  gem "therubyrhino", require: false if RUBY_PLATFORM == "java"
  gem "pry", require: false

  group :test do
    gem "simplecov", require: false
    gem "luna-rspec-formatters", require: false
    gem "rubocop", require: false
  end
end

# --
# Anything within this group is considered optional.
# You don't need it to run Jekyll-Assets, but they may
#   provide more features for you to use.
# --
group :optionals do
  gem "uglifier", require: false
  gem "autoprefixer-rails", require: false
  gem "font-awesome-sass", "~> 4.4", require: false
  gem "image_optim_pack", "~> 0.5", require: false
  gem "image_optim", "~> 0.25", require: false
  gem "mini_magick", "~> 4.2", require: false
  gem "babel-transpiler", require: false
  gem "bootstrap", require: false
end
