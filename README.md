[![Build Status](https://travis-ci.org/jekyll-assets/jekyll-assets.png?branch=master)](https://travis-ci.org/jekyll-assets/jekyll-assets) [![Coverage Status](https://coveralls.io/repos/jekyll-assets/jekyll-assets/badge.png?branch=master)](https://coveralls.io/r/jekyll-assets/jekyll-assets) [![Code Climate](https://codeclimate.com/github/jekyll-assets/jekyll-assets/badges/gpa.svg)](https://codeclimate.com/github/jekyll-assets/jekyll-assets) [![Dependency Status](https://gemnasium.com/jekyll-assets/jekyll-assets.svg)](https://gemnasium.com/jekyll-assets/jekyll-assets)


## Are you looking for the docs for Jekyll Assets < 2.0.0?

See: https://github.com/jekyll-assets/jekyll-assets/tree/legacy#jekyllassets

# Jekyll 3 Assets

Jekyll 3 assets is an asset pipeline using Sprockets 3 for Jekyll 3.  This
software is deeply alpha and still is missing pieces from old Jekyll-Assets
so beware when you use it, these pieces will be added soon (tm.)

## Configuration

```yaml
assets:
  cdn: https://cdn.example.com
  prefix: "/assets"
  assets:
    - "*.png"
    - "bundle.css"
  digest: true
  sources:
    - "_assets/folder"
```

### Do I need to provide `assets`?

No, you don't.  That is there to make your life easier when it comes to
missing assets in a cached chain.  Take for example bundle.css, if you use
that file in another asset or with a tag it will get compiled because we
detect that the best we can, but if you change that file and it uses
a PNG image and you delete that PNG image it will not get readded because
it's cached and not compiled so our methods never get called so you'll
need to add it to the asset list so it's always compiled for you.

## Asset Digesting

We will digest assets by default in production and default to non-digested
assets for efficiency in development/testing, this way we can ensure that your
builds remain fast in Jekyll3, you can however force asset digesting with
`digest:true` which will digest even in development and kick on deep regen
integration which ***will*** result in increased build times because every
asset change will cause the entire site to rebuild.

### What about caching?

Worry not, see: https://github.com/jekyll/jekyll/pull/3792 (https://github.com/jekyll/jekyll/commit/931c3b149030edcedaf59eb42516e65088fa2c93#diff-eeca36730c9db808f27e5c330dc7838fR57) which will *should* land in Jekyll3 and will provide built-in support
for non-caching in development.

## When I try to use ERB I get an error

Because we disable ERB processing in the hopes that this can one day be
used on Github Pages to help you with caching, so we remove access to ERB
which will give you powerful syntax with Ruby to do what you like.

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

* Sending `argument` is a boolean HTML argument.
* Sending `key:value` is an HTML key="value" if no proxy exists.
* Sending `proxy:key:value` will set a proxy key with the given value.
* Sending `proxy:key` is a boolean argument if the proxy and key exists.
* Sending `unknown:key:value` will raise `DoubleColonError`, escape it.
* Sending `proxy:unknown:value` will raise a `UnknownProxyError`.

Lets say we have `sprockets` proxies and sprockets allows you to proxy
accept, if you send `{% img src sprockets:accept:image/gif }` then Sprockets
find_asset will get `{ :accept => "image/gif" }` but if you try to proxy
"unknown" on sprockets we will raise a Proxy error.  For more information
then look at `parser_spec.rb` in the spec folder because it literally lays out
the ground rules for our tags as a specification.

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
* `magick:quality` - Allows you to set image quality.

## Hooks

* :env => [
    :pre_init, :post_init
  ]

You can register and trigger hooks like so:

```ruby
Jekyll::Assets::Hook.trigger  :env, :post_init
Jekyll::Assets::Hook.register :env, :post_init do
  # Your Work
end
```

## Optional Processing Engines

* CSS Auto Prefixer - add "autoprefixer-rails" to your Gemfile.
* ES6 Transpiler (through Babel) - add "sprockets-es6" to your Gemfile.
* Stylus - add "stylus" and "tilt" to your gemfile.

### Engine Settings

Some engines take settings, if they do you can add them like so:

```YAML
assets:
  engines:
    stylus:
      "option": "value"
```

Some options are removed (intentionally) such as options to set paths
and if we cannot adjust that, then we flat out ignore options until a white
list of options can be created.

## Plugins where did they go?

They're dead, in the way that they were, use Hooks, they require less
patching and give more flexibility to us because we can trigger them every
time we have a new environment not just occasionally.
