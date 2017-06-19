# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Liquid
      if defined?(::Liquid::ParseContext)
        class ParseContext < ::Liquid::ParseContext
          #
        end
      else
        class ParseContext < Array
          #
        end
      end
    end
  end
end
