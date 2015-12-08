# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register :site, :after_reset do |jekyll|
  Jekyll::Assets::Env.new(jekyll)

  jekyll.sprockets.excludes.each do |exclude|
    unless jekyll.config["exclude"].grep(%r!\A#{Regexp.escape(exclude)}/?!).size > 0
      jekyll.config["exclude"] << exclude
    end
  end
end
