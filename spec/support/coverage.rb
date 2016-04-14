# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2015 Jordon Bedwell - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

begin
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter \
    .start

rescue LoadError
  nil
end
