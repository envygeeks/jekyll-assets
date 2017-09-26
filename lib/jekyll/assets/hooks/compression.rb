# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init do
  if compress?("css")
    self.css_compressor = :sass
  end

  if compress?("js")
    try_require "uglifier" do
      opts = opts = self.asset_config.fetch("external", {}).fetch("uglifier", nil)
      self.js_compressor = !jekyll.safe && opts ?
        Uglifier.new(opts.symbolize_keys) :
          :uglify
    end
  end
end
