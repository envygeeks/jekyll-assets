# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

# --
# @see plugins/**/*
# Require all our plugins.
# @return [nil]
# --
dir = Pathutil.new(__dir__).join("defaults")
dir.children do |v|
  unless v.directory?
    require v
  end
end
