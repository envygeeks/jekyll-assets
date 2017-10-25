# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

if RUBY_ENGINE == "jruby"
  ExecJS.runtime = ExecJS::Runtimes::Node
end
