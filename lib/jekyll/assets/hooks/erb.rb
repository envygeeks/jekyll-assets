# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Assets::Hook.register :env, :init, :early do
  self.config = hash_reassoc(config, :engines) do |hash|
    hash.delete(
      ".erb"
    )

    hash
  end
end
