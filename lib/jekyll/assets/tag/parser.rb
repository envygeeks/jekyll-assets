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

        ACCEPT = { "css" => "text/css", "js" => "application/javascript" }
        ACCEPT["javascript"] = ACCEPT[ "js"]
        ACCEPT["style"]      = ACCEPT["css"]
        ACCEPT["stylesheet"] = ACCEPT["css"]
        ACCEPT.freeze

        PROXY = {
          "sprockets" => [
            "accept",
            "write_to"
          ],

          # See: https://github.com/minimagick/minimagick#usage -- All but
          #   the boolean @ options are provided by Minimagick.

          "magick" => [
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
              parse_col_arg(
                h, k
              )

            else
              h[:html][k] = \
                true
            end

            h
          end
        end

        # Parse colon:argument and modify the incomming hash based on that.
        # 1. engine:key:value (engine exists)  { engine => { key => value }}
        # 2. engine:key:value (engine not exists)  UnescapedDoubleColonError
        # 3. engine:key:value (engine exists, key unknown) UnknownProxyError
        # 4. key:value { :html => { key => value }}
        #
        # See: parser_spec.rb for more information, the first example is a
        #   literal example of what we parse and how.

        private
        def parse_col_arg(h, k)
          k[-1] = k[-1].gsub(/\\:/, ":")
          if k.size == 3 && PROXY[k[0]] && PROXY[k[0]] && \
                PROXY[k[0]].include?(k[1])

            h[k[0].to_sym][k[1].to_sym] = \
              k[2]
          elsif k.size == 3 && PROXY[k[0]]
            raise(
              UnknownProxyError
            )

          elsif k.size == 2 && PROXY[k[0]] && PROXY[k[0]].include?("@#{k[1]}")
            h[k[0].to_sym][k[1].to_sym] = \
              true

          elsif k.size == 2
            h[:html][k[0]] = \
              k[1]

          else
            raise(
              UnescapedDoubleColonError
            )
          end
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
          Shellwords.shellwords(
            @raw_args
          )
        end
      end
    end
  end
end
