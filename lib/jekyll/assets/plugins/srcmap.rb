# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      Hook.register :env, :after_init, priority: 3 do
        unless Utils.old_sprockets?
          require_relative "srcmap/srcmap"
          SrcMap.register_on(self)
        end
      end
    end
  end
end
