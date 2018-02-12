# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

if Jekyll::Assets::Utils.activate("crass")
  module Jekyll
    module Assets
      module Plugins
        NODER = %r!/\*\! @alternate \*/!
        RTEST = %r!#{Regexp.union(%w(-ms- -webkit- -moz- -o-).freeze)}!
        NODE1 = { node: :whitespace, pos: 28, raw: " " }.freeze
        NODE2 = {
          raw: "/*! @alternate */",
          pos: 0, # It's ignored. @see Crass::Parser.stringify
          value: "! @alternate ",
          node: :comment,
        }.freeze

        NODE3 = {
          raw: "/* @alternate */",
          pos: 0, # It's ignored. @see Crass::Parser.stringify
          value: "@alternate ",
          node: :comment,
        }.freeze

        class Alternates
          def call(input)
            comp = input[:environment].asset_config[:compression]
            data = Crass.parse(input[:data] || "", preserve_comments: true)
            data.each do |v|
              next unless v[:node] == :style_rule
              v[:children] = v[:children].each_with_object([]) do |c, a|
                if alternate?(c)
                  a << (comp ? NODE2 : NODE3)
                  a << NODE1
                end

                a << c
              end
            end

            {
              data: Crass::Parser.stringify(data, {
                preserve_comments: true,
              }),
            }
          end

          private
          def alternate?(c)
            c[:node] == :property && (
              c[:name] =~ RTEST || c[:value] =~ RTEST
            )
          end
        end

        # --
        # When compression is enabled we need to make sure to
        # run an extra step, because when compression is being
        # ran, we have to guard with /*! so we've to strip.
        # --
        Hook.register :asset, :after_compression do |_, o, t|
          next unless t == "text/css"

          o.update({
            # Remember we guard against compression.
            data: o[:data].gsub(NODER, " #{NODE3[:raw]} "),
          })
        end

        # --
        Hook.register :env, :after_init, priority: 2 do
          register_bundle_processor "text/css",
            Alternates.new
        end
      end
    end
  end
end
