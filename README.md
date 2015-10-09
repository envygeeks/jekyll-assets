[![Build Status](https://travis-ci.org/jekyll-assets/jekyll-assets.png?branch=master)](https://travis-ci.org/jekyll-assets/jekyll-assets) [![Coverage Status](https://coveralls.io/repos/jekyll-assets/jekyll-assets/badge.png?branch=master)](https://coveralls.io/r/jekyll-assets/jekyll-assets) [![Code Climate](https://codeclimate.com/github/jekyll-assets/jekyll-assets/badges/gpa.svg)](https://codeclimate.com/github/jekyll-assets/jekyll-assets) [![Dependency Status](https://gemnasium.com/jekyll-assets/jekyll-assets.svg)](https://gemnasium.com/jekyll-assets/jekyll-assets)


## Are you looking for the docs for Jekyll Assets < 2.0.0?

See: https://github.com/jekyll-assets/jekyll-assets/tree/legacy#jekyllassets

# Jekyll 3 Assets

Jekyll 3 assets is an asset pipeline using Sprockets 3 to build especially
for Jekyll 3.  It utilizes new features of both Sprockets and Jekyll to achieve
a clean and extensible assets platform for Jekyll.

## Configuration

```yaml
assets:
  cache: false | directory | default: .asset-cache
  cdn: https://cdn.example.com
  skip_prefix_with_cdn: false
  prefix: "/assets"
  assets:
    - "*.png"
    - "bundle.css"
  digest: true
  sources:
    - "_assets/folder"
```

## Asset Digesting

* Disable digesting by default in development.
* Digest by default in production

***You can force digesting with `digest: true` in your `_config.yml`***

## ERB Support

ERB Support is removed in favor of trying to get this included on Github Pages
eventually (if I can.) Having ERB presents a security risk to Github because it
would allow you to use Ruby in ways they don't want you to.

## Tags

* stylesheet, css, style
* javascript, js
* image, img
* asset_path

### Tag Example:

```liquid
{% img src magick:2x alt:'This is my alt' %}
{% img src magick:2x alt:'This is my alt' sprockets:accept:image/gif %}
```

### What do the colons mean? Proxies/Tags

* `argument` is a boolean HTML argument.
* `key:value` is an HTML key="value" if no proxy exists.
* `proxy:key:value` will set a proxy key with the given value.
* `proxy:key` is a boolean argument if the proxy and key exists.
* `unknown:key:value` will raise `DoubleColonError`, escape it.
* `proxy:unknown:value` will raise a `UnknownProxyError`.

Lets say we have `sprockets` proxies and sprockets allows you to proxy accept,
if you send `{% img src sprockets:accept:image/gif }` then Sprockets find_asset
will get `{ :accept => "image/gif" }` but if you try to proxy "unknown" on
sprockets we will raise a Proxy error.  For more information then look at
`parser_spec.rb` in the spec folder because it literally lays out the ground
rules for our tags as a specification.

### Current Proxies:

* `sprockets:accept:<value>` - Tell Sprockets your preferred content type.
* `sprockets:write_to:<value>` - The filename you wish us to write your file to.
* `magick:resize:<value>` - Takes standard ImageMagick resize values.
* `magick:format:<value>` - Takes standard ImageMagick format values.
* `magick:rotate:<value>` - Takes standard ImageMagick resize values.
* `magick:crop:<value>` - Takes standard ImageMagick crop values.
* `magick:flip:<value>` - Takes standard ImageMagick flip values.
* `magick:2x` - Tells us to write a double width/height image.
* `magick:4x` - Tells us to write a quadruple width/height image.
* `magick:half` - Tells us to shrink the image to half.

## Filters

There is a full suite of filters, actually, any tag and any proxy can be a
filter by way of filter arguments, take the following example:

```liquid
{{ src | img : "magick:2x" }}
```

## Hooks

* `:env => [
    :pre_init, :post_init
  ]`

You can register and trigger hooks like so:

```ruby
Jekyll::Assets::Hook.trigger  :env, :post_init
Jekyll::Assets::Hook.register :env, :post_init do
  # Your Work
end
```

## Optional Processing Engines

* ES6 Transpiler (through Babel) - add "sprockets-es6" to your Gemfile.
* CSS Auto Prefixer - add "autoprefixer-rails" to your Gemfile.

***Please note that some of these (if not all) have trouble with Rhino --
`therubyrhino` so you would probably be best to just use Node.js or io.js at
that point rather than trying to fight it.***

### Engine Settings

Some engines take settings, if they do you can add them like so:

```YAML
assets:
  engines:
    engine_name:
      option: value
```

Only whitelisted options are allowed by default, so that we can guard against
using paths we don't want to be used.  If you wish to have an option
whitelisted please file a ticket or submit a pull request.

## Plugins where did they go?

They're dead, in the way that they were, use Hooks, they require less
patching and give more flexibility to us because we can trigger them every
time we have a new environment not just occasionally.
