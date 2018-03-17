# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# rubocop:disable Metrics/BlockLength
# Encoding: utf-8

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jekyll/assets/version"

Gem::Specification.new do |s|
  s.require_paths = ["lib"]
  s.version = Jekyll::Assets::VERSION
  s.homepage = "http://github.com/jekyll/jekyll-assets/"
  s.authors = ["Jordon Bedwell", "Aleksey V Zapparov", "Zachary Bush"]
  s.email = ["jordon@envygeeks.io", "ixti@member.fsf.org", "zach@zmbush.com"]
  s.files = %w(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  s.summary = "Assets for Jekyll"
  s.name = "jekyll-assets"
  s.license = "MIT"

  s.description = <<~TXT
    A drop-in Jekyll Plugin that provides an asset pipeline for JavaScript,
    CSS, SASS, SCSS.  Based around Sprockets (from Rails) and just as powereful
    it provides everything you need to manage assets in Jekyll.
  TXT

  s.required_ruby_version = ">= 2.3.0"
  s.add_runtime_dependency("execjs", "~> 2.7")
  s.add_runtime_dependency("uglifier", "~> 4.0")
  s.add_runtime_dependency("nokogiri", "~> 1.8")
  s.add_runtime_dependency("activesupport", "~> 5.0")
  s.add_runtime_dependency("fastimage", ">= 1.8", "~> 2.0")
  s.add_runtime_dependency("sprockets", ">= 3.3", "< 4.1.beta")
  s.add_runtime_dependency("liquid-tag-parser", "~> 1.0")
  s.add_runtime_dependency("jekyll", ">= 3.5", "< 4.0")
  s.add_runtime_dependency("jekyll-sanity", "~> 1.2")
  s.add_runtime_dependency("pathutil", "~> 0.16")
  s.add_runtime_dependency("extras", "~> 0.2")
  s.add_development_dependency("rspec", "~> 3.4")
end
