# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      module ClosureComments
        def self.call(input)
          theregex = %r!/\*(\W+@alternat(e|ive)\W+)\*/!
          input[:data].gsub!(theregex, "/*!\\1*/")
        end
      end

      # --
      %w(text/css text/scss text/sass).each do |v|
        Sprockets.register_preprocessor v, ClosureComments
      end
    end
  end
end

# --
Jekyll::Assets::Hook.register :asset, :before_write do |v|
  theregex = %r!/\*\!(\W+@alternat(e|ive)\W+)\*/;?!

  if v.content_type == "text/css"
    src = v.to_s.gsub(theregex, "/*\\1*/")
    v.metadata[:digest] = Sprockets::DigestUtils.digest(src)
    v.instance_variable_set(:@source, src)
  end
end
