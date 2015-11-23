# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register :site, :after_reset do |jekyll|
  unless jekyll.config["exclude"].grep(/\A\.asset\-cache\/?/).size > 0
    jekyll.config["exclude"].push(".asset-cache/")
  end
end
