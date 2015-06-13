# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll/assets/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-assets"
  spec.version       = Jekyll::Assets::VERSION
  spec.homepage      = "http://jekyll-assets.github.com/jekyll-assets"
  spec.authors       = ["Aleksey V Zapparov", "Zachary Bush"]
  spec.email         = %w(ixti@member.fsf.org zach@zmbush.com)
  spec.license       = "MIT"
  spec.summary       = "jekyll-assets-#{Jekyll::Assets::VERSION}"
  spec.description   = <<-DESC
  Jekyll plugin, that allows you to write javascript/css assets in
  other languages such as CoffeeScript, Sass, Less and ERB, concatenate
  them, respecting dependencies, minify and many more.
  DESC

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(/^bin\//).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll",       ">= 2"
  spec.add_dependency "sass",         "~> 3.2"
  spec.add_dependency "fastimage",    "~> 1.6"
  spec.add_dependency "mini_magick",  "~> 4.1"
  spec.add_dependency "sprockets",    "~> 2.10"
  spec.add_dependency "sprockets-sass"
  spec.add_dependency "sprockets-helpers"

  spec.add_development_dependency "bundler", "~> 1.6"
end
