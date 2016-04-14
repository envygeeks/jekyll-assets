# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Hooks.register :site, :after_reset do |jekyll|
  Jekyll::Assets::Env.new(jekyll)

  excludes = Set.new(jekyll.config["exclude"])
  jekyll.sprockets.excludes.map(&excludes.method(:add))
  jekyll.config["exclude"] = excludes.to_a
end
