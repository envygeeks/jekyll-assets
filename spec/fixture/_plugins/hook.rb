# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

Jekyll::Hooks.register %i(pages documents posts), :pre_render do |_, p|
  p["hello"] = {
    "world" => "img.png",
  }
end
