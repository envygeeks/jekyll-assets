# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init do
  if compress?("css")
    self.css_compressor = :sass
  end

  if compress?("js")
    try_require "uglifier" do
      self.js_compressor = :uglify
    end
  end
end
