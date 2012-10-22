require 'jekyll'
require 'liquid'


require 'jekyll/assets_plugin/generator'
require 'jekyll/assets_plugin/site_patch'
require 'jekyll/assets_plugin/tag'
require 'jekyll/assets_plugin/version'


Jekyll::Site.send :include, Jekyll::AssetsPlugin::SitePatch


Liquid::Template.register_tag('javascript', Jekyll::AssetsPlugin::Tag)
Liquid::Template.register_tag('stylesheet', Jekyll::AssetsPlugin::Tag)
Liquid::Template.register_tag('asset_path', Jekyll::AssetsPlugin::Tag)
Liquid::Template.register_tag('asset',      Jekyll::AssetsPlugin::Tag)
