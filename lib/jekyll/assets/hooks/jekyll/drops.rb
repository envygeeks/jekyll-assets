# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Hooks.register :site, :pre_render do |jekyll, payload|
  payload["assets"] = jekyll.sprockets.to_liquid_payload
end
