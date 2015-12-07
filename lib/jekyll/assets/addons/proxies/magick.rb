# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

try_require "mini_magick" do
  args = %W(resize quality rotate crop flip)
  presets = %W(@2x @4x @1/2 @1/3 @2/3 @1/4 @2/4 @3/4
    @double @quadruple @half @one-third @two-thirds @one-fourth
      @two-fourths @three-fourths)

  Jekyll::Assets::Env.liquid_proxies.add :magick, :img, *(args + presets) do
    PRESETS = presets
    ARGS = args

    class DoubleResizeError < RuntimeError
      def initialize
        "Both resize and @*x provided, this is not supported."
      end
    end

    # @see https://github.com/minimagick/minimagick#usage -- All but
    #   the boolean @ options are provided by Minimagick.

    def initialize(asset, opts, args)
      @path = asset.filename
      @opts = opts
      @asset = asset
      @args = args
    end

    #

    def process
      img = MiniMagick::Image.open(@path)
      private_methods(true).select { |v| v =~ /\Amagick_/ }.each do |method|
        send(method, img)
      end

      img.write(
        @path
      )
    ensure
      img.destroy!
    end

    #

    private
    def any_preset?(*keys)
      @opts.keys.any? do |key|
        keys.include?(key)
      end
    end

    #

    private
    def preset?
      (@opts.keys - ARGS.map(&:to_sym)).any?
    end

    #

    private
    def magick_quality(img)
      if @opts.key?(:quality)
        then img.quality @opts[:quality]
      end
    end

    #

    private
    def magick_resize(img)
      raise DoubleResizeError if @opts.key?(:resize) && preset?
      if @opts.key?(:resize)
        then img.resize @opts[:resize]
      end
    end

    #

    private
    def magick_rotate(img)
      if @opts.key?(:rotate)
        then img.rotate @opts[:rotate]
      end
    end

    #

    private
    def magick_flip(img)
      if @opts.key?(:flip)
        then img.flip @opts[:flip]
      end
    end

    #

    private
    def magick_crop(img)
      if @opts.key?(:crop)
        then img.crop @opts[:crop]
      end
    end

    # I just want you to know, we don't even care if you do multiple
    # resizes or try to, we don't attempt to even attempt to attempt to care
    # we expect you to be logical and if you aren't we will comply.

    private
    def magick_preset_resize(img)
      return unless preset?
      width, height = img.width * 4, img.height * 4 if any_preset?(:"4x", :quadruple)
      width, height = img.width * 2, img.height * 2 if any_preset?(:"2x", :double)
      width, height = img.width / 2, img.height / 2 if any_preset?(:"1/2", :half)
      width, height = img.width / 3, img.height / 3 if any_preset?(:"1/3", :"one-third")
      width, height = img.width / 4, img.height / 4 if any_preset?(:"1/4", :"one-fourth")
      width, height = img.width / 3 * 2, img.height / 3 * 2 if any_preset?(:"2/3", :"two-thirds")
      width, height = img.width / 4 * 2, img.height / 4 * 2 if any_preset?(:"2/4", :"two-fourths")
      width, height = img.width / 4 * 3, img.height / 4 * 3 if any_preset?(:"3/4", :"three-fourths")
      img.resize "#{width}x#{height}"
    end
  end
end
