[![Build Status](https://travis-ci.com/envygeeks/jekyll-assets.svg?branch=master)](https://travis-ci.com/envygeeks/jekyll-assets) [![Maintainability](https://api.codeclimate.com/v1/badges/56f67324553069bf51e7/maintainability)](https://codeclimate.com/github/envygeeks/jekyll-assets/maintainability)

# Jekyll Assets

Jekyll Assets is a drop in [asset
pipeline](http://guides.rubyonrails.org/asset_pipeline.html) that uses
[Sprockets](https://github.com/rails/sprockets) to build specifically
for Jekyll. It utilizes [Sprockets](https://github.com/rails/sprockets),
and [Jekyll](https://jekyllrb.com) to try and achieve a clean, and
extensible assets platform that supports plugins, caching, converting your
assets. It even supports proxying of said assets in a way that does not
interfere with either [Sprockets](https://github.com/rails/sprockets),
or [Jekyll](https://jekyllrb.com), or your own source.  By default you
can add Jekyll Assets to your Gemfile, as a plugin, and have it act as
a drop-in replacement for Jekyll's basic SASS processors, with you only
having to add it to your Gemfile, and updating your `<img>`, and `<link>`.

## Installing

```ruby
gem "jekyll-assets", group: :jekyll_plugins
gem "jekyll-assets", git: "https://github.com/envygeeks/jekyll-assets", group: :jekyll_plugins
gem "jekyll-assets", "~> x.x.alpha", group: :jekyll_plugins
```

---

### System Requirements

* `ruby`: ***2.6+***
* `sprockets`: ***4.0+***
* `uglifier`: ***4.0***
* `jekyll`: ***3.5+***

---

## Configuration

The configuration file is the same as Jekyll's, which is `_config.yml`.
Except we use the special key called `assets` inside of that file.
All values listed below are default, you need not copy these into your
configuration file unless you plan to change a value. *Setting a value makes
it explicit, and shared across both **production**, and **development**.*

```yaml
# _config.yml
assets:
  source_maps: true
  destination: "/assets"
  compression: false
  gzip: false
  defaults:
    integrity:
      {css,img,js}: false
  caching:
    enabled: true
    path: ".jekyll-cache/assets"
    type: file
  # --
  # Assets you wish to always have compiled.
  #   This can also be combined with raw_precompile which
  #   copies assets without running through the pipeline
  #   making them ultra fast.
  # --
  precompile: []
  raw_precompile: [
    #
  ]
  # --
  # baseurl: whether or not to append site.baseurl
  # destination: the folder you store them in on the CDN.
  # url: the CDN url (fqdn, or w/ identifier).
  # --
  cdn:
    baseurl: false
    destination: false
    url: null
  # --
  # See lib/jekyll/assets/config.rb
  #   for a list of defaults
  # --
  sources:
    - _assets/custom
  plugins:
    css: { autoprefixer: {}}
    img: { optim: {}}
```

## Tag `{% asset %}`, `<img>`

```html
{% asset src @magick:double alt='This is my alt' %}
{% asset src @magick:double alt='This is my alt' %}
<img src="src" asset="@magick:double" alt="This is my alt">
<img src="src" alt="This is my alt" asset>
```

## Defaults

We provide several defaults that get set when you run an asset, depending on
content type, this could be anything from type, all the way to integrity.
 *If there is a default attribute you do not wish to be included, you can
disable the attribute with `!attribute`, and it will be skipped over.*

```liquid
{% asset img.png !integrity %}
{% asset bundle.css !type   %}
```

### Arguments

Our tags will take any number of arguments, arbitrary or not... and
convert them to HTML, and even attach them to your output if the
HTML processor you use accepts that kind of data.  ***This applies
to anything but hashes, and arrays.*** So adding say, a class, or
id, is as easy as doing `id="val"` inside of your tag arguments.

#### Built In

| Arg | Description | Type | Return Type |
|---|---|---|---|
| `@data` | `data` URI | `*/*` | `text` |
| `@inline` | CSS `<style>` | `text/css` | `text/html` |
| `@path` | Path | `*/*` | `text` |

## Responsive Images
### `<img>` usage
#### Configuration

| Option | Tag Option | Type | Description |
|---|---|---|---|
| responsive.automatic | @responsive:automatic | Boolean | Upscale & Downscale images |
| responsive.automatic_min_width | @responsive:min_width | Integer | Stop scaling before this width |
| responsive.automatic_scales | responsive:scales | String | The scales to use |
| responsive.discovery_scales | responsive:scales | String | The scales to look for |
| responsive.automatic_upscale | @responsive:upscale | Upscale, the source instead of downscale |
| responsive.discovery | @responsive:discovery | Responsive if an img matching source w/ @<scale>x exists |

#### Example

```liquid
{% asset img.png @pic
    srcset:max-width="200"
    srcset:min-width="200"
    srcset:scales=1x
    srcset:scales=2x
    srcset:scales=3x
        %}
```

```html
<img srcset="
    img-<hash>.png 3x,
    img-<hash>.png 2x,
    img-<hash>.png 1x"
        >
```

#### Discovery

When using discovery based responsive images, we will only do responsive
images if we can find assets that match your scales based on the source
file.  For example if you do `{% asset img.png responsive:discovery
responsive:scales=1x responsive:scales=1.5x responsive:scales=2x %}` then
we will expect `img.png@1.5x` and `img.png@2x` to exist.  For any image
that doesn't exist it will be skipped, and that scale will not be included!

#### Automatic

Automatic responsive images/scaling can either upscale, or downscale.  This
is useful if you have a ton of images for blog posts, and you always want to
provide a single most high quality version and then have us downscale those,
or if you have an image and wish us to upscale it! The `argv1` of `{% asset
img.png %}` is where the source is derived from.  Given you give `2x`, `1.5x`
and `1x` if you choose to downscale, the source will be assumed to be 2x,
and we will downscale to 1.5x and half.  If you chose to upscale, the source
will be assumed to be 1x, and we will multiply the width by `1.5` and `2`


## Liquid

We support liquid arguments for tag values (but not tag keys), and we also
support Liquid pre-processing (with your Jekyll context) of most files if they
end with `.liquid`.  This will also give you access to our filters as well as
their filters, and Jekyll's filters, and any tags that are globally available.

```liquid
{% asset '{{ site.bg_img }}' %}
{% asset '{{ site.bg_img }}' proxy:key='{{ value }}' %}
{% asset {{\ site.bg_img\ }} %}
```

### `.sass`, `.scss`

```scss
body {
  background-image: asset_url("'{{ site.bg_img }}'");
  background-image: asset_url("'{{ site.bg_img }}' proxy:key='{{ value }}'");
  background-image: asset_url("{{\ site.bg_img\ }}");
}
```

### `.liquid.ext`
### `.ext.liquid`

#### Supported file types:

- .css
- .sass
- .scss
- .js
- .es6
- .coffee
- .svg

You have full access to your entire global context from any liquid processing
we do.  Depending on where you do it, you might or might not also have
access to your local (page) context as well. You can also do whatever you
like, and be as dynamic as you like, including full loops, and conditional
Liquid, since we pre-process your text files. *On Sprockets 4.x you can use
`.liquid.ext` and `.ext.liquid`, but because of the way Sprockets 3.x works, we
have opted to only allow the default extension of `.ext.liquid` when running
on "Old Sprockets" (AKA 3.x.)  If you would like Syntax + Liquid you should
opt to install Sprockets 4.x so you can get the more advanced features.*

#### Importing

***In order to import your Liquid pre-processed assets inside of Liquid or JS
*you should use a Sprockets `//require=`, Sprockets does not integrate that
*deeply into JavaScript and SASS to allow you to `@import` and pre-process.***

## `.sass`, `.scss` Helpers

We provide two base helpers, `asset_path` to return the path of an asset,
and `asset_url` which will wrap `asset_path` into a `url()` for you,
making it easy for you to extract your assets and their paths inside of
SCSS.  All other helpers that Sprockets themselves provide will use our
`asset_path` helper, so you can use them like normal, *including with Liquid*

```scss
body {
  background-image: asset_url("img.png");
}
```

### Proxies, and Other Arguments

Any argument that is supported by our regular tags, is also supported by
our `.sass`/`.scss` helpers, with a few obvious exceptions (like `srcset`).
 This means that you can wrap your assets into `magick` if you wish, or
`imageoptim` or any other proxy that is able to spit out a path for you
to use.  The general rule is, that if it returns a path, or `@data` then
it's safe to use within `.scss`/`.sass`, otherwise it will probably throw.

```scss
body {
  background-image: asset_url("img.png @magick:half")
}
```

*Note: we do not validate your arguments, so if you send a conflicting
*argument that results in invalid CSS, you are responsible for that, in
*that if you ship us `srcset` we might or might not throw, depending on how
*the threads are ran. So it might ship HTML if you do it wrong, and it will
*break your CSS, this is by design so that if possible, in the future, we can
*allow more flexibility, or so that plugins can change based on arguments.*

## Listing Assets in Liquid

We provide all *your* assets as a hash of Liquid Drops so you can
get basic info that we wish you to have access to without having to
prepare the class. **Note:** The keys in the `assets` array are the
names of the original files, e.g., use `*.scss` instead of `*.css`.

```liquid
{{ assets["bundle.css"].content_type }} => "text/css"
{{ assets["images.jpg"].width  }} => 62
{{ assets["images.jpg"].height }} => 62
```

The current list of available accessors:

| Method         | Description                |
| -------------- | -------------------------- |
| `content_type` | The RFC content type       |
| `filename`     | The full path to the asset |
| `height`       | The asset height           |
| `width`        | The asset width            |
| `digest_path`  | The prefixed path          |
| `integrity`    | The SRI hash               |

### Looping

```liquid
{% for k,v in assets %}
  {{ k }}
{% endfor %}
```

### Dynamic

Using Liquid Drop `assets`, you can check whether an asset is present.

```liquid
{% if assets[page.image] %}{% img '{{ page.image }}' %}
{% else %}
  {% img default.jpg %}
{% endif %}
```

## Filter

```liquid
{{ src | asset:"@magick:double magick:quality=92" }}
```

## Hooks

| Point | Name | Instance | Args |
| ---| --- | --- | --- |
| `:env` | `:before_init` | ✔ | ✗ |
| `:env` | `:after_init` | ✔ | ✗ |
| `:env` | `:after_write` | ✔ | ✗ |
| `:config` | `:before_merge` | ✗ | `Config{}` |
| `:asset` | `:before_compile` | ✗ | `Asset`, `Manifest` |
| `:asset` | `:after_compression` | ✗ | input{}, output{}, type=*/* |

### Example

```ruby
Jekyll::Assets::Hook.register :env, :before_init do
  append_path "myPluginsCustomPath"
end
```

```ruby
Jekyll::Assets::Hook.register :config, :init do |c|
  c.deep_merge!({
    plugins: {
      my_plugin: {
        opt: true
      }
    }
  })
end
```

#### Plugin Hooks

Your plugin can also register it's own hooks on our Hook system,
so that you can trigger hooks around your stuff as well,
this is useful for extensive plugins that want more power.

```ruby
Jekyll::Assets::Hook.add_point(
  :plugin, :hook
)
```

```ruby
Jekyll::Assets::Hook.trigger(:plugin, :hook)  { |v| v.call(:arg) }
Jekyll::Assets::Hook.trigger(:plugin, :hook) do |v|
  instance_eval(&v)
end
```

## Default Plugins
### Google Closure Alternates
```
gem "crass"
```

Once crass is added, we will detect vendor prefixes, and
add `/* @alternate */` to them, with or without compression
enabled, and with protections against compression stripping.

### Font Awesome

```ruby
gem "font-awesome-sass"
```

```scss
@import "font-awesome-sprockets";
@import "font-awesome";
html {
  // ...
}
```

### CSS Auto-Prefixing

```ruby
gem "autoprefixer-rails"
```

```yml
assets:
  autoprefixer:
    browsers:
    - "last 2 versions"
    - "IE > 9"
```

### Bootstrap

```ruby
gem "bootstrap-sass" # 3.x
gem "bootstrap"      # 4.x
```

```scss
@import 'bootstrap';
html {
  // ...
}
```

```scss
//=require _bootstrap.css
//=require bootstrap/_reboot.css
```

### ImageMagick

```ruby
gem "mini_magick"
```

#### Args

See the [MiniMagick docs](https://github.com/minimagick/minimagick#usage)
to get an idea what `<value>` can be.

| Name                        | Accepts Value |
| --------------------------- | ------------- |
| `magick:compress`           | ✔             |
| `magick:resize`             | ✔             |
| `magick:format`<sup>*</sup> | ✔             |
| `magick:quality`            | ✔             |
| `magick:rotate`             | ✔             |
| `magick:gravity`            | ✔             |
| `magick:crop`               | ✔             |
| `magick:extent`             | ✔             |
| `magick:flip`               | ✔             |
| `magick:background`         | ✔             |
| `magick:transparency`       | ✔             |
| `@magick:double`            | ✗             |
| `@magick:half`              | ✗             |

<sup>\*</sup> *`magick:format` requires an ext or a valid MIME content type like `image/jpeg` or `.jpg`.  We will `ImageMagick -format` on your behalf with that information by getting the extension.*

### ImageOptim

```ruby
gem "image_optim"
gem "image_optim_pack" # Optional
```

#### Configuration

```yml
assets:
  plugins:
    img:
      optim:
        {}
```

Check the [ImageOptim](https://github.com/toy/image_optim#configuration) to get idea about configuration options, and to get a list of stuff you need to install on your system to use it, if you do not wish to use "image_optim_pack".

To disable ImageOptim (i.e. for development builds), use following configuration:

```yml
assets:
  plugins:
    img:
      optim: false
```

#### Args

| Name                              | Accepts Value |
| --------------------------------- | ------------- |
| `optim`                           | ✔             |
| `@optim`                          | ✗             |

***By default `@optim` will use the default `jekyll`, otherwise you can provide `optim=preset` and have it used that preset.  ImageOptim provides advanced, and default as their default presets, you can define your own preset via Jekyll Assets configuration listed above.***

### LibVIPS

```ruby
gem "ruby-vips"
```

The "ruby-vips" gem requires a functional install
of (libvips)[https://github.com/libvips/libvips/].

#### Args

| Name                  | Accepts Value |
| --------------------- | ------------- |
| `vips:crop`           | ✔             |
| `vips:resize`         | ✔             |
| `vips:format`         | ✔             |
| `vips:quality`        | ✔             |
| `vips:compression`    | ✔             |
| `@vips:near_lossless` | ✗             |
| `@vips:interlace`     | ✗             |
| `@vips:lossless`      | ✗             |
| `vips:strip`          | ✔             |
| `@vips:strip`         | ✗             |
| `@vips:double`        | ✗             |
| `@vips:half`          | ✗             |

##### vips:resize

Accepts an argument of either 'width', 'x<height>' or '<width>x<height>'.
All resize processes keep the original aspect ratio so width and
height are used to specify the bounding box for the resize process.

If no height is specified the image is resized to fit withing a
bounding box of 'width' x 'width'. Similarly specifying just a
height sets the bounding box for the resize to 'height' x 'height'.
This form only exists for compatibility with the "magick" plugin.

```liquid
{% asset img.png vips:resize='x100' %}
{% asset img.png vips:resize='100x50' %}
{% asset img.png vips:resize='100x' %}
```

##### vips:format

Convert the image to the specified format. Format support
depends on the compile options of the libvips library. Format is
specified as the file extension such as '.jpg', '.webp' or '.png'.

```liquid
{% asset image.png vips:format='.webp' %}
```

##### vips:crop

Only has any effect when combined with "vips:resize". Use
the following arguments (all except "fill" are documented
[here](http://libvips.github.io/libvips/API/current/libvips-conversion.html#VipsInteresting)):

* fill: resize the image to the specified size while maintaining the
        aspect ratio then fills the "empty" background with blurred version
        of the original image
* entropy: use an entropy measure
* high: position the crop towards the high coordinate
* attention: look for features likely to draw human attention
* low: position the crop towards the low coordinate
* centre: crop from the centre
* none: do nothing

```liquid
{% asset image.jpg vips:resize='100' vips:crop='fill' %}
```

##### vips:strip

Removes metadata from images. This is set "true" by
default, but can be disabled by passing "false".

```liquid
{% asset image.jpg vips:strip=false %}
```

### Building Your Own Plugins
#### Globals

| Name      | Class                   |
| --------- | ----------------------- |
| `env`    | `Jekyll::Assets::Env`   |
| `args`   | `Liquid::Tag::Parser{}` |
| `jekyll` | `Jekyll::Site`          |
| `asset`  | `Sprockets::Asset`      |

#### HTML

| Name   | Class                      | Type            |
| ------ | -------------------------- | --------------- |
| `@doc` | `Nokogiri:: XML::Document` | `image/svg+xml` |
| `@doc` | `Nokogiri::HTML::Document` | `image/*`       |
