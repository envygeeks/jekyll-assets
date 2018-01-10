# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module SprocketsFileReaderPatches
  def call(input)
    before_hook(input); out = super; after_hook(out); out
  end

  # --
  private
  def before_hook(input)
    Jekyll::Assets::Hook.trigger :asset, :before_read do |v|
      v.call(input)
    end
  end

  # --
  private
  def after_hook(input)
    Jekyll::Assets::Hook.trigger :asset, :after_read do |v|
      v.call(input)
    end
  end
end

module Sprockets
  class FileReader
    class << self
      prepend SprocketsFileReaderPatches
    end
  end
end
