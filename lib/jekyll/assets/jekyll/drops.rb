# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register :site, :pre_render do |j, p|
  p["assets"] = j.sprockets.to_liquid_payload
end
