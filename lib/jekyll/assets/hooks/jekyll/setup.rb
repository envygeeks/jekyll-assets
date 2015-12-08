# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register :site, :after_reset do |jekyll|
  Jekyll::Assets::Env.new(jekyll)

  dir = File.basename(jekyll.sprockets.in_cache_dir)
  unless jekyll.config["exclude"].grep(%r!\A#{Regexp.escape(dir)}/?!).size > 0
    jekyll.config["exclude"] << dir
  end
end
