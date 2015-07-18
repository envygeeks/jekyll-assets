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
          @tag = tag
          @raw_args = args
          parse
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

        private
        def parse
          @args = sort_args(Shellwords.shellwords(@raw_args).inject({}) do |h, k|
            h.update(:argv => Set.new) unless h.has_key?(:argv)
            h.update(:args => Set.new) unless h.has_key?(:args)

            if (k = k.split(/(?<!\\):/)).size >= 3
              raise UnescapedDoubleColonError
            end

            if k.size == 2
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
          end)
        end

        private
        def sort_args(args)
          add_proxy(args.inject({ :proxy => {}, :other => {} }) do |h, (k, v)|
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
          end)
        end

        private
        def add_proxy(args)
          unless args[:proxy][:accept]
            then args[:proxy][:accept] = ACCEPT[
              @tag
            ]
          end

          args
        end
      end
    end
  end
end
