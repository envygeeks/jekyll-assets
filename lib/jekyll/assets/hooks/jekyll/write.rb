# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Hooks.register :site, :post_write do |jekyll|
  if jekyll.sprockets.asset_config["autowrite"]
    then jekyll.sprockets.write_all
  end
end
