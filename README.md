[![](https://travis-ci.org/jekyll/jekyll-assets.png?branch=master)][travis]
[![](https://coveralls.io/repos/jekyll/jekyll-assets/badge.png?branch=master)][coveralls]
[![](https://codeclimate.com/github/jekyll/jekyll-assets/badges/gpa.svg)][code-climate] [![](https://gemnasium.com/jekyll/jekyll-assets.svg)][gemnasium]

[gemnasium]: https://gemnasium.com/jekyll/jekyll-assets
[code-climate]: https://codeclimate.com/github/jekyll/jekyll-assets
[coveralls]: https://coveralls.io/r/jekyll/jekyll-assets
[travis]: https://travis-ci.org/jekyll/jekyll-assets

# Jekyll 3 Assets

Jekyll 3 assets is an asset pipeline using Sprockets 3 to build especially
for Jekyll 3.  It utilizes new features of both Sprockets and Jekyll to achieve
a clean and extensible assets platform for Jekyll.

## Using Jekyll Assets with Jekyll

When you are using a Gemfile and bundler you need to do nothing special to get
Jekyll Assets to work, it will automatically load itself and work with Jekyll
when you bundle install and run Jekyll through bundle exec. However, when you
have globally installed Gems (`gem install jekyll-assets`) then in your
`_config.yml` do:

```yaml
gems:
  - jekyll-assets
```

## Configuration

```yaml
assets:
  compress:
    css: false | true | default - development: false, production: true
     js: false | true | default - development: false, production: true
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

### Digesting

* Disable digesting by default in development.
* Digest by default in production

### Compression

* Requires sass and uglify.
* Disable compression by default in development.
* Enable by default in production.

***You can force digesting with `digest: true` in your `_config.yml`***

## ERB Support

ERB Support is removed in favor of trying to get this included on Github Pages
eventually (if I can.) Having ERB presents a security risk to Github because it
would allow you to use Ruby in ways they don't want you to.

## Tags

* image, img
* javascript, js
* stylesheet, css, style
* asset, asset_source
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

* `sprockets:accept:<value>`
* `sprockets:write_to:<value>`

## Filters

There is a full suite of filters, actually, any tag and any proxy can be a
filter by way of filter arguments, take the following example:

```liquid
{{ src | img : "magick:2x magick:quality:92" }}
```

## Hooks

* `:env => [:init]`

You can register and trigger hooks like so:

```ruby
Jekyll::Assets::Hook.register :env, :init do
  # Your Work
end
```

## Addons

* CSS Auto Prefixer - add "autoprefixer-rails" to your Gemfile.
* ES6 Transpiler (through Babel) - add "sprockets-es6" to your Gemfile.
* Image Magick - add "mini_magick"  to your Gemfile, only works with `img`, `image`.
* Font Awesome - add "font-awesome-sass" to your Gemfile.

***Please note that some of these (if not all) have trouble with Rhino --
`therubyrhino` so you would probably be best to just use Node.js or io.js at
that point rather than trying to fight it.***

### Image Magick Proxy arguments:

* `magick:resize:<value>`
* `magick:format:<value>`
* `magick:quality:<value>`
* `magick:rotate:<value>`
* `magick:crop:<value>`
* `magick:flip:<value>`
* `magick:half`
* `magick:2x`
* `magick:4x`

## Plugins where did they go?

They're dead, in the way that they were, use Hooks, they require less
patching and give more flexibility to us because we can trigger them every
time we have a new environment not just occasionally.
