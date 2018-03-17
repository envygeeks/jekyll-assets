# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "fastimage"
require_relative "html"
require "liquid/tag/parser"
require "active_support/hash_with_indifferent_access"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/deep_merge"
require_relative "default"
require_relative "proxy"
require "nokogiri"

module Jekyll
  module Assets
    class Tag < Liquid::Tag
      class << self
        public :new
      end

      # --
      class MixedArg < StandardError
        def initialize(arg, mixed)
          super "cannot use #{arg} w/ #{mixed}"
        end
      end

      # --
      class InvalidExternal < StandardError
        def initialize(arg)
          super "cannot use `#{arg}' with external url's"
        end
      end

      # --
      attr_reader :name
      attr_reader :tokens
      attr_reader :args
      attr_reader :tag

      # --
      def initialize(tag, args, tokens)
        @tag = tag.to_sym
        @tokens = tokens
        @args = args
        super
      end

      # --
      def render_raw(ctx)
        env = ctx.registers[:site].sprockets

        args = Liquid::Tag::Parser.new(@args)
        args = env.parse_liquid(args, ctx: ctx)
        raise_unfound_asset_on(ctx: ctx, with: args) unless args.key?(:argv1)
        asset = external(ctx, args: args) if env.external?(args)
        asset ||= internal(ctx, args: args)
        [args, asset]
      end

      # --
      # @return [String]
      # Render the tag, run the proxies, set the defaults.
      # @note Defaults are ran twice just incase the content type
      #   changes, at that point there might be something that
      #   has to change in the new content.
      # --
      def render(ctx)
        env = ctx.registers[:site].sprockets; args, asset = render_raw(ctx)
        env.logger.debug args.to_h(html: false).inspect

        return_or_build(ctx, args: args, asset: asset) do
          HTML.build({
            args: args,
            asset: asset,
            ctx: ctx,
          })
        end
      # --
      rescue Sprockets::FileNotFound => e
        e_not_found(e, {
          ctx: ctx,
        })
      # --
      rescue ExecJS::RuntimeError => e
        e_exjs(e, {
          args: args,
          ctx: ctx,
        })
      # --
      # @note you can --trace to get this same info
      # Handle errors that Sass ships because Jekyll finds
      # error handling hard, and makes it even harder, so we
      # need to ship debug info to the user, or they'll
      # never get it. That's not very good.
      # --
      rescue Sass::SyntaxError => e
        e_sass(e, {
          args: args,
          ctx: ctx,
        })
      end

      # --
      def return_or_build(ctx, args:, asset:)
        methods.grep(%r!^on_(?\!or_build$)!).each do |m|
          out = send(m, args, ctx: ctx, asset: asset)
          if out
            return out
          end
        end

        yield
      end

      # --
      # Returns the path to the asset.
      # @example {% asset img.png @path %}
      # @return [String]
      # --
      def on_path(args, ctx:, asset:)
        env = ctx.registers[:site].sprockets

        return unless args[:path]
        raise InvalidExternal, "@path" if env.external?(args)
        env.prefix_url(asset.digest_path)
      end

      # --
      # Returns the data uri of an object.
      # @example {% asset img.png @data-url %}
      # @example {% asset img.png @data_uri %}
      # @return [String]
      # --
      def on_data(args, ctx:, asset:)
        env = ctx.registers[:site].sprockets

        return unless args[:data]
        raise InvalidExternal "@data" if env.external?(args)
        asset.data_uri
      end

      # --
      # @param [Liquid::Context] ctx
      # Set's up an external url using `Url`
      # @return [Url]
      # --
      def external(ctx, args:)
        env = ctx.registers[:site].sprockets
        out = env.external_asset(args[:argv1], args: args)
        Default.set(args, ctx: ctx, asset: out)

        out
      end

      # --
      # @param [Liquid::Context] ctx
      # Set's up an internal asset using `Sprockets::Asset`
      # @return [Sprockets::Asset]
      # --
      def internal(ctx, args:)
        env = ctx.registers[:site].sprockets
        original = env.find_asset!(args[:argv1])
        Default.set(args, ctx: ctx, asset: original)
        out = Proxy.proxy(original, args: args, ctx: ctx)
        env.assets_to_write |= [out.logical_path]

        Default.set(args, {
          ctx: ctx, asset: out
        })

        out
      end

      # --
      private
      def raise_unfound_asset_on(ctx:, with:)
        raise Sprockets::FileNotFound, "Unknown asset `#{with[:argv1]}'" \
          " in #{ctx.registers[:page]['relative_path']}"
      end

      # --
      def e_not_found(e, ctx:)
        lines = e.message.each_line.to_a
        page   = ctx.registers[:page]&.[]("relative_path")
        page ||= ctx.registers[:page]&.[]("path")

        lines[0] = lines[0].strip + " in `#{page || 'Untraceable'}'\n\n"
        raise e.class, lines.join
      end

      # --
      private
      def e_exjs(e, ctx:, args:)
        env = ctx.registers[:site].sprockets

        env.logger.error e.message
        env.logger.err_file args[:argv1]
        raise e.class, "JS Error"
      end

      # --
      private
      def e_sass(e, ctx:, args:)
        env = ctx.registers[:site].sprockets

        env.logger.error e.message
        env.logger.err_file env.strip_paths(e.backtrace.first)
        env.logger.error "error from file #{args[:argv1]}" if args
        raise e.class, "Sass Error"
      end
    end
  end
end

# --

Liquid::Template.register_tag "asset", Jekyll::Assets::Tag
