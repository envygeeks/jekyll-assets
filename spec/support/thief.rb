# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

class Thief < Liquid::Tag
  class << self
    attr_accessor :ctx
  end

  # --
  def render(ctx)
    self.class.ctx = ctx
  end
end

# --
Liquid::Template.register_tag "thief", Thief
