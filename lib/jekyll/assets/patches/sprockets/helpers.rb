# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "sprockets/helpers"
Sprockets::Helpers.instance_methods.reject { |v| v=~ /^(path_to_|assets_environment$)/ }.each do |m|
  Sprockets::Helpers.send(:define_method, m.to_s.gsub(/_path$/, "_url")) do |*args|
    %Q(url("#{send(m, *args)}"))
  end
end

module Sprockets
  module Helpers
    alias_method :_old_ap, :asset_path

    def rcache
      return @resolver_cache ||= {
        #
      }
    end

    def asset_path(asset, h = {})
      return unless out = _old_ap(asset)
      path = environment.find_asset(resolve_without_compat(asset))
      environment.parent.used.add(path)
    out
    end
  end
end
