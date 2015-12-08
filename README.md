[![](https://travis-ci.org/jekyll/jekyll-assets.png?branch=master)][travis]
[![](https://codeclimate.com/github/jekyll/jekyll-assets/badges/coverage.svg)][coverage]
[![](https://codeclimate.com/github/jekyll/jekyll-assets/badges/gpa.svg)][code-climate] [![](https://gemnasium.com/jekyll/jekyll-assets.svg)][gemnasium]

[gemnasium]: https://gemnasium.com/jekyll/jekyll-assets
[code-climate]: https://codeclimate.com/github/jekyll/jekyll-assets
[coverage]: https://codeclimate.com/github/jekyll/jekyll-assets/coverage
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

A lot of our configuration transforms based on the `JEKYLL_ENV` variable
set in your environment.  Such as digesting and whether or not to enable the
CDN.  Some of them can be explicitly overridden but a few cannot right now.
You should set your `JEKYLL_ENV=development` on your development
machine and `JEKYLL_ENV=production` when building to push.

```yaml
assets:
  compress:
    css: false | true | default - development: false, production: true
     js: false | true | default - development: false, production: true
  cache: false | directory | default: .asset-cache
  cdn: https://cdn.example.com
  skip_baseurl_with_cdn: false
   skip_prefix_with_cdn: false
  prefix: "/assets"
  assets:
    - "*.png"
    - "bundle.css"
  digest: true
  sources:
    - _assets/css
    - _assets/images
    - _assets/javascripts
    - _assets/stylesheets
    - _assets/fonts
    - _assets/img
    - _assets/js
  features:
    automatic_img_size: true | false | default: true
    automatic_img_alt : true | false | default: true
```

### Cache Folder

If you plan to change the `cache` folder, please make sure to add that
folder to your `exclude` list in Jekyll or you will generate over and over
and over again, `.` folders are not ignored by default.

### Sources

The listed resources in the example are all defaults. It should be noted
that we append your sources instead of replace our resources with yours.  So
if you add "_assets/folder" then we will append that to our sources and
both will work.

***NOTE: if you use our `_assets` base folder container as a base folder for
your sprockets, we will not append our sources, we will only use that
folder as the sole source (base folder.)***

### Digesting

* Disable digesting by default in development.
* Digest by default in production

***You can force digesting with `digest: true` in your `_config.yml`***

### Compression

* Requires sass and uglify.
* Disable compression by default in development.
* Enable by default in production.


### Bower Components

Modify your `.bowerrc` file and add:

```javascript
{
  "directory": "_assets/bower"
}
```

And then add `_assets/bower` to your sources list and Sprockets will do the
the rest for you... you can even `//= require bower_asset.js`.  We will even
compress them for you per normal if Sprockets supports it and allows us to.

***You do not need to modify your `.bowerrc` file, you can optionally just
add it to your sources list and it will work that way too!  As long as it's in
your Jekyll folder.***

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

## Liquid Variables

We support liquid arguments for tag values (but not tag keys), and we also
support Liquid pre-processing (with your Jekyll context) sass/less/css files
you need do nothing special for the preprocessing an entire file, it's
always done.

An example of using Liquid in your tags:

```liquid
{% img '{{ image_path }}' %}
{% img '{{ image_path }}' proxy:key:'{{ value }}' %}
{% img {{\ image_path\ }} %}
```

An example of using Liquid in your SCSS:

```scss
.bg {
  background: url(asset_path("{{ site.background_image }}"));
}
```

You have full access to your entire Jekyll context from any liquid
processing we do, so you can do whatever you like and be as dynamic as you
like, including full loops and conditional Liquid based CSS since we
pre-process your text files.

## Getting a list of your assets and basic info from Liquid

We provide all *your* assets as a hash of Liquid Drops so you can get basic
info that we wish you to have access to without having to prepare the class.

```liquid
{{ assets["bundle.css"].content_type }} => "text/css"
{{ assets["images.jpg"].width  }} => 62
{{ assets["images.jpg"].height }} => 62
```

The current list of available accessors:

* `logical_path`
* `content_type` -> `type`
* `filename`
* `basename`
* `width`
* `height`

If you would like more, please feel free to add a pull request, at this
time we will reject all pull requests that wish to add any digested paths as
those are dynamically created when a proxy is ran so we can never predict
it reliably unless we proxy and that would be a performance problem.

## ERB Support

ERB Support is removed in favor of trying to get this included on Github Pages
eventually (if I can.) Having ERB presents a security risk to Github because it
would allow you to use Ruby in ways they don't want you to.

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

## Sass Helpers

***Our currently supported helpers are:***

* asset_path
* image_path
* font_path

## Addons

* CSS Auto Prefixer - add "autoprefixer-rails" to your Gemfile.
* ES6 Transpiler (through Babel) - add "sprockets-es6" to your Gemfile.
* Image Magick - add "mini_magick"  to your Gemfile, only works with `img`, `image`.
* Bootstrap - add "bootstrap-sass" to your Gemfile and "@import 'bootstrap'"
* Compass - add "compass-core" to your Gemfile and "@import 'compass'"
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
* `magick:quadruple`, `magick:4x`
* `magick:one-third`, `magick:1/3`
* `magick:three-fourths`, `magick:3/4`
* `magick:two-fourths`, `magick:2/4`
* `magick:two-thirds`, `magick:2/3`
* `magick:one-fourth`, `magick:1/4`
* `magick:half`, `magick:1/2`

## Plugins where did they go?

They're dead, in the way that they were, use Hooks, they require less
patching and give more flexibility to us because we can trigger them every
time we have a new environment not just occasionally.

## Having trouble with our documentation?

If you do not understand something in our documentation please feel
free to file a ticket and it will be explained and the documentation updated,
however... if you have already figured out the problem please feel free to
submit a pull request with clarification in the documentation and we'll
happily work with you on updating it.
