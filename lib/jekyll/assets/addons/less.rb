# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

try_require_if_javascript "jekyll/assets/processors/less" do
  if ExecJS.runtime.is_a?(ExecJS::RubyRhinoRuntime)
    Jekyll.logger.warn "ES6 transpiler has trouble with RubyRhino, use Node"
  end
end
