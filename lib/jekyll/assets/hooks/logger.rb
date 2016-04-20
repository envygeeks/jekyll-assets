# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Assets::Hook.register :env, :init do
  if jekyll.config["verbose"]
    self.logger = Jekyll::Assets::Logger.new
  end
end
