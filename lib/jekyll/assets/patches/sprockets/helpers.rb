# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "sprockets/helpers"
Sprockets::Helpers.instance_methods.reject { |v| v=~ /^(path_to_|assets_environment$)/ }.each do |m|
  Sprockets::Helpers.send(:define_method, m.to_s.gsub(/_path$/, "_url")) do |*args|
    %Q(url("#{send(m, *args)}"))
  end
end
