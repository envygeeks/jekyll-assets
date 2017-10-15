# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Manifest < Sprockets::Manifest
      attr_reader :data
    end
  end
end
