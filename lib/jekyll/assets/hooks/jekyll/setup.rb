# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Hooks.register :site, :after_reset do |jekyll|
  Jekyll::Assets::Env.init(
    jekyll
  )
end
