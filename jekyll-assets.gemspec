$:.unshift(File.expand_path("../lib", __FILE__))
require "jekyll/assets/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Assets::VERSION
  spec.homepage = "http://github.com/envygeeks/ruby-jekyll3-assets/"
  spec.authors = ["Jordon Bedwell", "Aleksey V Zapparov", "Zachary Bush"]
  spec.email = ["jordon@envygeeks.io", "ixti@member.fsf.org", "zach@zmbush.com"]
  spec.files = %W(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "Assets for Jekyll"
  spec.name = "jekyll3-assets"
  spec.license = "MIT"
  spec.has_rdoc = false
  spec.require_paths = ["lib"]
  spec.description =   spec.description   = <<-DESC
    A Jekyll plugin, that allows you to write javascript/css assets in
    other languages such as CoffeeScript, Sass, Less and ERB, concatenate
    them, respecting dependencies, minify and many more.
  DESC

  spec.add_runtime_dependency("sprockets", "~> 3.2")
  spec.add_runtime_dependency("sprockets-helpers", "~> 1.2")
  spec.add_runtime_dependency("jekyll", "~> 3.0.0.pre.beta8")

  spec.add_development_dependency("nokogiri", "~> 1.6")
  spec.add_development_dependency("envygeeks-coveralls", "~> 1.0")
  spec.add_development_dependency("luna-rspec-formatters", "~> 3.3")
  spec.add_development_dependency("rspec", "~> 3.3")
end
