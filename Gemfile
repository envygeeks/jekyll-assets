# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

source "https://rubygems.org"
gemspec

sv = "~> 4.0.beta1"
mv = "<  4.0.beta9"
gem "sprockets", ENV["SPROCKETS_VERSION"] || sv, ENV["SPROCKETS_MAX_VERSION"] || mv, require: false
# rubocop:disable Bundler/DuplicatedGem
if ENV["JEKYLL_VERSION"]
  gem "jekyll", ENV["JEKYLL_VERSION"], {
    require: false,
  }
elsif ENV["JEKYLL_BRANCH"]
  gem "jekyll", {
    git: "https://github.com/jekyll/jekyll",
    branch: ENV["JEKYLL_BRANCH"],
  }
end
