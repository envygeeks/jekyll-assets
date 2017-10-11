# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init do
  opts = asset_config[:plugins][:compression]

  if opts[:css][:enabled]
    self.css_compressor = :sass
  end

  if opts[:js][:enabled]
    try_require "uglifier" do
      self.js_compressor = !jekyll.safe ?
        Uglifier.new(opts[:js][:opts]) \
        : :uglify
    end
  end
end

Jekyll::Assets::Hook.register :config, :pre do |c|
  c.deep_merge!({
    plugins: {
      compression: {
        js: {
          enabled: true,
          opts: {
            #
          }
        },

        css: {
          enabled: true,
        }
      }
    }
  })
end
