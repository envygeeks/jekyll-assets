# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register :site, :post_write do |jekyll|
  jekyll.sprockets.write_all if jekyll.sprockets.asset_config["autowrite"]
end
