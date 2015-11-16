try_require "mini_magick" do
  args = %W(resize quality rotate crop flip @2x @4x @half)
  Jekyll::Assets::Env.liquid_proxies.add :magick, :img, *args do
    class DoubleResizeError < RuntimeError
      def initialize
        "Both resize and @*x provided, this is not supported."
      end
    end

    # @see https://github.com/minimagick/minimagick#usage -- All but
    #   the boolean @ options are provided by Minimagick.

    def initialize(asset, opts)
      @asset, @path, @opts = asset, asset.filename, opts
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
    def magick_quality(img)
      if @opts.has_key?(:quality)
        then img.quality @opts[:quality]
      end
    end

    #

    private
    def magick_resize(img)
      if @opts.has_key?(:resize) && (@opts.has_key?(:"2x") || \
            @opts.has_key?(:"4x") || @opts.has_key?(:half))
        raise DoubleResizeError

      elsif @opts.has_key?(:resize)
        then img.resize @opts[:resize]
      end
    end

    #

    private
    def magick_rotate(img)
      if @opts.has_key?(:rotate)
        then img.rotate @opts[:rotate]
      end
    end

    #

    private
    def magick_flip(img)
      if @opts.has_key?(:flip)
        then img.flip @opts[:flip]
      end
    end

    #

    private
    def magick_crop(img)
      if @opts.has_key?(:crop)
        then img.crop @opts[:crop]
      end
    end

    #

    private
    def magick_preset_resize(img)
      return unless @opts.has_key?(:"2x") || @opts.has_key?(:"4x") || @opts.has_key?(:half)
      width, height = img.width * 2, img.height * 2 if @opts.has_key?(:"2x")
      width, height = img.width * 4, img.height * 4 if @opts.has_key?(:"4x")
      width, height = img.width / 2, img.height / 2 if @opts.has_key?(:half)
      img.resize "#{width}x#{height}"
    end
  end
end
