# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

if RUBY_ENGINE == "jruby"
  ExecJS.runtime = ExecJS::Runtimes::Node
end
