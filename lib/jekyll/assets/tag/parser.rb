require "forwardable"

module Jekyll
  module Assets

    # Examples:
    #   - {% tag value argument:value %}
    #   - {% tag value "argument:value" %}
    #   - {% tag value argument:"I have spaces" %}
    #   - {% tag value argument:value\:with\:colon %}
    #   - {% tag value argument:"I can even escape \\: here too!" %}
    #   - {% tag value proxy:key:value %}

    class Tag
      class Parser
        attr_reader :args, :raw_args
        extend Forwardable

        def_delegator :@args, :to_h
        def_delegator :@args, :has_key?
        def_delegator :@args, :fetch
        def_delegator :@args, :[]

        ACCEPT = {
          "css" => "text/css", "js" => "application/javascript"
        }.\
        freeze

        PROXY = {
          "data" => {
            :for => :all,
            :key => [
              "@uri"
            ]
          },

          "sprockets" => {
            :for => :all,
            :key => [
              "accept",
              "write_to"
            ]
          },

          # See: https://github.com/minimagick/minimagick#usage -- All but
          #   the boolean @ options are provided by Minimagick.

          "magick" => {
            :for => "img",
            :key => [
              "resize",
              "format",
              "rotate",
              "crop",
              "flip",
              "@2x",
              "@4x",
              "@half"
            ]
          }
        }

        class UnknownProxyError < StandardError
          def initialize
            super "Unknown proxy argument."
          end
        end

        class UnescapedDoubleColonError < StandardError
          def initialize
            super "Unescaped double colon argument."
          end
        end

        def initialize(args, tag)
          @raw_args, @tag = args, tag

          parse_raw
          set_accept
        end

        def to_html
          @args[:html].map do |k, v|
            %Q{ #{k}="#{v}"}
          end. \
          join
        end

        # Parse the string that we get like we would parse a command line
        # so that people can escape, quote and do all sorts of fancy stuff with
        # their tags to get data to us without much resistance.

        private
        def parse_raw
          @args = from_shellwords.each_with_index.inject(dhash) do |h, (k, i)|
            if i == 0
              h[:file] = \
                k

            elsif k =~ /:/ && (k = k.split(/(?<!\\):/))
              parse_col_arg h, k

            else
              h[:html][k] = \
                true
            end

            h
          end
        end

        # Parse colon:argument and modify the incomming hash based on that.
        # See: parser_spec.rb for more information, the first example is a
        #   literal example of what we parse and how.

        private
        def parse_col_arg(h, k)
          k[-1] = k[-1].gsub(/\\:/, ":")
          if k.size == 3
            parse_as_proxy h, k

          elsif k.size == 2
            parse_as_boolean_or_html h, k
          end
        end

        # Any argument that is key:value, if there is a proxy and the
        # proxy key exists we assume it's a boolean setter for the proxy and
        # if it doesn't then we assume it's an HTML argument.

        private
        def parse_as_boolean_or_html(h, k)
          if is_proxy?(k[0]) && PROXY[k[0]][:key].include?("@#{k[1]}")
            h[k[0].to_sym][k[1].to_sym] = \
              true

          else
            h[:html][k[0]] = \
              k[1]
          end
        end

        # Anything that comes is a proxy:key:value.  If the proxy exists
        # then we check if the key exists and if it does then we set the value
        # on the key for the proxy.  If the proxy exists but the key is
        # not allowed we will raise a ProxyError and if the Proxy doesn't
        # exists we will raise an DoubleColon error, escape your colons.

        private
        def parse_as_proxy(h, k)
          if is_proxy?(k[0]) && PROXY[k[0]][:key].include?(k[1])
            h[k[0].to_sym][k[1].to_sym] = \
              k[2]

          elsif k.size == 3 && is_proxy?(k[0])
            raise UnknownProxyError

          else
            raise \
              UnescapedDoubleColonError
          end
        end

        #

        def is_proxy?(k)
          PROXY[k] && (PROXY[k][:for] == :all || PROXY[k][:for] == @tag)
        end

        # If you try to tap bundle and you have bundle.css and bundle.js
        # it will return whichever one it chooses to parse first, so by default
        # we add a proxy with accept so that we can pick out what we would
        # prefer to be the default so you can do it Rails Style.
        #
        # This can also be achieved by you with accept:content_type on tag.

        private
        def set_accept
          if !@args[:sprockets][:accept] && (accept = ACCEPT[@tag])
            then @args[:sprockets][:accept] = \
              accept
          end
        end

        private
        def dhash
          Hash.new do |h, k|
            h[k] = {}
          end
        end

        private
        def from_shellwords
          Shellwords.shellwords(@raw_args)
        end
      end
    end
  end
end
