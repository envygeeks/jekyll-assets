# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jekyll/assets_plugin/version', __FILE__)


Gem::Specification.new do |gem|
  gem.name          = "jekyll-assets"
  gem.version       = Jekyll::AssetsPlugin::VERSION
  gem.homepage      = "http://ixti.github.com/jekyll-assets"
  gem.authors       = %w{Aleksey V Zapparov}
  gem.email         = %w{ixti@member.fsf.org}
  gem.summary       = "jekyll-assets-#{Jekyll::AssetsPlugin::VERSION}"
  gem.description   = %q{Adds assets pipelines for Jekyll}

  gem.add_dependency "jekyll"
  gem.add_dependency "sprockets", "~> 2.8"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rb-inotify"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.require_paths = ["lib"]
end
