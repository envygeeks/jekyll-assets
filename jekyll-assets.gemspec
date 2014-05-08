# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/assets_plugin/version'


Gem::Specification.new do |spec|
  spec.name          = "jekyll-assets"
  spec.version       = Jekyll::AssetsPlugin::VERSION
  spec.homepage      = "http://ixti.github.com/jekyll-assets"
  spec.authors       = ["Aleksey V Zapparov"]
  spec.email         = %w{ixti@member.fsf.org}
  spec.license       = "MIT"
  spec.summary       = "jekyll-assets-#{Jekyll::AssetsPlugin::VERSION}"
  spec.description   = <<-DESC
  Jekyll plugin, that allows you to write javascript/css assets in
  other languages such as CoffeeScript, Sass, Less and ERB, concatenate
  them, respecting dependencies, minify and many more.
  DESC

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll",    ">= 1.0.0", "< 3.0.0"
  spec.add_dependency "sprockets", "~> 2.10"
  spec.add_dependency "sass"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "compass"
  spec.add_development_dependency "bourbon"
  spec.add_development_dependency "neat"
  spec.add_development_dependency "bootstrap-sass"

  # compass fails with SASS than 3.3+
  # https://github.com/chriseppstein/compass/issues/1513
  spec.add_development_dependency "sass", "~> 3.2.13"
end
