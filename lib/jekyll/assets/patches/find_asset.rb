# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module Sprockets
  class Environment
    unless method_defined?(:find_asset!)
      def find_asset!(*args)
        cached.find_asset!(*args)
      end
    end
  end
end
