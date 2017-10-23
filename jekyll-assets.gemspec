$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jekyll/assets/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Assets::VERSION
  spec.homepage = "http://github.com/jekyll/jekyll-assets/"
  spec.authors = ["Jordon Bedwell", "Aleksey V Zapparov", "Zachary Bush"]
  spec.email = ["jordon@envygeeks.io", "ixti@member.fsf.org", "zach@zmbush.com"]
  spec.files = %W(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "Assets for Jekyll"
  spec.name = "jekyll-assets"
  spec.license = "MIT"
  spec.has_rdoc = false
  spec.require_paths = ["lib"]
  spec.description = spec.description = <<-DESC
    A Jekyll plugin, that allows you to write javascript/css assets in
    other languages such as CoffeeScript, Sass, Less and ERB, concatenate
    them, respecting dependencies, minify and many more.
  DESC

  spec.add_runtime_dependency("rack", "~> 1.6")
  spec.add_runtime_dependency("nokogiri", "~> 1.8")
  spec.add_runtime_dependency("activesupport", "~> 5.0")
  spec.add_runtime_dependency("concurrent-ruby", "~> 1.0")
  spec.add_runtime_dependency("fastimage", ">= 1.8", "~> 2.0")
  spec.add_runtime_dependency("sprockets", ">= 3.3", "< 4.1.beta")
  spec.add_runtime_dependency("liquid-tag-parser", "~> 1.0")
  spec.add_runtime_dependency("jekyll", ">= 3.5", "< 4.0")
  spec.add_runtime_dependency("jekyll-sanity", "~> 1.2")
  spec.add_runtime_dependency("pathutil", "~> 0.16")
  spec.add_runtime_dependency("extras", "~> 0.2")

  spec.add_development_dependency("nokogiri", "~> 1.6")
  spec.add_development_dependency("luna-rspec-formatters", "~> 3.5")
  spec.add_development_dependency("rspec", "~> 3.4")
end
