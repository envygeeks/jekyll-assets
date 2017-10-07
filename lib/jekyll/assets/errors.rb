# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Errors
      class AssetNotFound < StandardError
        def initialize(path)
          super "unable to find the asset #{path}"
        end
      end
    end
  end
end
