# Frozen-string-literal: true
# Copyright: 2012 - 2020 - MIT License
# rubocop:disable Bundler/DuplicatedGem
# Encoding: utf-8

source "https://rubygems.org"
gemspec

s_version = "~> 4.0"
j_version = "~> 4.0"
gem "sprockets", ENV["SPROCKETS_VERSION"] || s_version, require: false
if ENV["JEKYLL_VERSION"]
  gem "jekyll", ENV["JEKYLL_VERSION"], {
    require: false,
  }
elsif ENV["JEKYLL_BRANCH"]
  gem "jekyll", {
    git: "https://github.com/jekyll/jekyll",
    branch: ENV["JEKYLL_BRANCH"],
  }
else
  gem "jekyll", j_version
end
