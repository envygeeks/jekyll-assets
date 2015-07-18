module Jekyll
  module Assets

    # -------------------------------------------------------------------------
    # Examples:
    #   - {% tag value argument:value %}
    #   - {% tag value "argument:value" %}
    #   - {% tag value argument:"I have spaces" %}
    #   - {% tag value argument:value\:with\:colon %}
    #   - {% tag value argument:"I can even escape \\: here too!" %}
    # -------------------------------------------------------------------------

    class Tag
      class Parser
        attr_reader :args, :raw_args

        ACCEPT = { "css" => "text/css", "js" => "application/javascript" }
        ACCEPT["javascript"] = ACCEPT[ "js"]
        ACCEPT["style"]      = ACCEPT["css"]
        ACCEPT["stylesheet"] = ACCEPT["css"]
        ACCEPT.freeze
        PROXY = ["accept"]. \
          freeze

        class UnescapedDoubleColonError < StandardError
          def initialize
            super "Unescaped double colon argument."
          end
        end

        def initialize(args, tag)
          @raw_args, @tag = args, tag

          parse_raw
          sort_base_args
          set_proxy
        end

        def [](key)
          @args[
            key
          ]
        end

        def to_html
          @args[:other].map do |k, v|
            %Q{ #{k}="#{v}"}
          end. \
          join
        end

        # Very rudamentary sort before we do a more fine-grained sort
        # later in the code, this basically just takes the first arg and then
        # every other non-colon (valued) argument and pushes it.

        private
        def parse_raw
          @args = from_shellwords.inject(base_args) do |h, k|
            if (k = k.split(/(?<!\\):/)).size >= 3
              raise UnescapedDoubleColonError

            elsif k.size == 2
              h.update(
                k[0] => k[1].gsub(
                  /\\:/, ":"
                )
              )
            else
              h[h[:argv].size == 1 ? :args : :argv] << \
                k[0]
            end

            h
          end
        end

        # If it's not a proxy argument (going into Sprockets) or an
        # argument that sets a boolean choice for us (such as convert) then
        # we pass it onto other, where it will become an HTML attr.

        private
        def sort_base_args
          @args = @args.inject({ :proxy => {}, :other => {} }) do |h, (k, v)|
            if PROXY.include?(k)
              then h[:proxy].update(
                k.to_sym => v
              )

            elsif k == :argv
              h[:argv] = v. \
                first

            elsif k == :args
              h[:args] = v. \
                to_a

            else
              h[:other].update(
                k => v
              )
            end

            h
          end
        end

        # If you try to tap bundle and you have bundle.css and bundle.js
        # it will return whichever one it chooses to parse first, so by default
        # we add a proxy with accept so that we can pick out what we would
        # prefer to be the default so you can do it Rails Style.
        #
        # This can also be achieved by you with accept:content_type on tag.

        private
        def set_proxy
          unless @args[:proxy][:accept]
            then @args[:proxy][:accept] = ACCEPT[
              @tag
            ]
          end
        end

        private
        def base_args
          {
            :argv => Set.new,
            :args => Set.new
          }
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
