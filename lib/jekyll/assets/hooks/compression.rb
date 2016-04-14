# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Assets::Hook.register :env, :init do
  if compress?("css")
    self.css_compressor = :sass
  end

  if compress?("js")
    try_require "uglifier" do
      if !jekyll.safe && (opts = self.asset_config.fetch("external", {}).fetch("uglifier", nil))
        self.js_compressor = Uglifier.new(
          opts.symbolize_keys
        )

      else
        self.js_compressor = \
          :uglify
      end
    end
  end
end
