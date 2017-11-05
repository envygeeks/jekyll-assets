# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Hooks.register [:pages, :documents, :posts], :pre_render do |_, p|
  p["hello"] = {
    "world" => "img.png",
  }
end
