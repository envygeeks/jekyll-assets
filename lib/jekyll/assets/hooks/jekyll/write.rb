# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register :site, :post_write do |jekyll|
  jekyll.sprockets.write_all
end
