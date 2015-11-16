# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register :site, :post_read do |jekyll|
  Jekyll::Assets::Env.new(jekyll)
end
