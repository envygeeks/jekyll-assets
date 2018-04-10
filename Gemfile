# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

source "https://rubygems.org"
gemspec

sv = "~> 4.0.beta"
gem "sprockets", ENV["SPROCKETS_VERSION"] || sv, require: false
if ENV["JEKYLL_VERSION"]
  gem "jekyll", ENV["JEKYLL_VERSION"], {
    require: false,
  }
end
