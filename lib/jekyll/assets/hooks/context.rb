# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

Jekyll::Assets::Hook.register :env, :init do
  context_class.class_eval(
    &self.class.context_patches
  )
end
