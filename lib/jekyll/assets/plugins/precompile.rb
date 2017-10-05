# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Hook.register :env, :init, priority: 3 do
  extra_assets.each do |k, v = manifest.find(k)|
    v.map do |sv|
      @manifest.compile(sv)
    end
  end
end
