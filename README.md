[![Code Climate](https://img.shields.io/codeclimate/maintainability/envygeeks/jekyll-assets.svg?style=for-the-badge)](https://codeclimate.com/github/envygeeks/jekyll-assets/maintainability)
[![Code Climate](https://img.shields.io/codeclimate/c/envygeeks/jekyll-assets.svg?style=for-the-badge)](https://codeclimate.com/github/envygeeks/jekyll-assets/coverage)
[![Travis CI](https://img.shields.io/travis/envygeeks/jekyll-assets/master.svg?style=for-the-badge)](https://travis-ci.org/envygeeks/jekyll-assets)
[![Donate](https://img.shields.io/badge/-DONATE-yellow.svg?style=for-the-badge)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=LKGZAWXLZ8ZPG)
![Gem Version](https://img.shields.io/gem/v/jekyll-assets.svg?style=for-the-badge)
![Gem DL](https://img.shields.io/gem/dt/jekyll-assets.svg?style=for-the-badge)

***Looking for information on what's changed? See https://envygeeks.io/2017/11/21/jekyll-assets-3-released***

# Jekyll Assets

Jekyll Assets is a drop in [asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) that uses [Sprockets](https://github.com/rails/sprockets) to build specifically for Jekyll. It utilizes [Sprockets](https://github.com/rails/sprockets), and [Jekyll](https://jekyllrb.com) to try and achieve a clean, and extensible assets platform that supports plugins, caching, converting your assets. It even supports proxying of said assets in a way that does not interfere with either [Sprockets](https://github.com/rails/sprockets), or [Jekyll](https://jekyllrb.com), or your own source.  By default you can add Jekyll Assets to your Gemfile, as a plugin, and have it act as a drop-in replacement for Jekyll's basic SASS processors, with you only having to add it to your Gemfile, and updating your `<img>`, and `<link>`.

## Installing

```ruby
gem "jekyll-assets", group: :jekyll_plugins
gem "jekyll-assets", git: "https://github.com/envygeeks/jekyll-assets", group: :jekyll_plugins
gem "jekyll-assets", "~> x.x.alpha", group: :jekyll_plugins
```

---

### System Requirements

* `ruby`: ***2.3+***
* `sprockets`: ***3.3+***
* `jekyll`: ***3.5+***

---

If you'd like SourceMaps, or *faster* Sprockets, opt to use Sprockets `4.0`, you can use it by placing it to your Gemfile.

```ruby
gem "sprockets", "~> 4.0.beta", {
  require: false
}
```

## Configuration

The configuration file is the same as Jekyll's, which is `_config.yml`. Except we use the special key called `assets` inside of that file. All values listed below are default, you need not copy these into your configuration file unless you plan to change a value. *Setting a value makes it explicit, and shared across both **production**, and **development**.*

```yaml
source_maps: true # false on JEKYLL_ENV=production
destination: "/assets"
compression: true
gzip: false
defaults:
   js: { integrity: false } # true on JEKYLL_ENV=production
  css: { integrity: false } # true on JEKYLL_ENV=production
  img: { integrity: false } # true on JEKYLL_ENV=production
caching:
  path: ".jekyll-cache/assets"
  type: file # Possible values: memory, file
  enabled: true
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
# These are all default. No need to add them
#   Only use this if you have more.
# --
sources:
  - assets/css
  - assets/fonts
  - assets/images
  - assets/videos
  - assets/javascript
  - assets/video
  - assets/image
  - assets/img
  - assets/js
  - _assets/css
  - _assets/fonts
  - _assets/images
  - _assets/videos
  - _assets/javascript
  - _assets/video
  - _assets/image
  - _assets/img
  - _assets/js
  - css
  - fonts
  - images
  - videos
  - javascript
  - video
  - image
  - img
  - js
plugins:
  css: { autoprefixer: {}}
  img: { optim: {}}
```

## Tag `{% asset %}`, `<img>`

```html
{% asset src @magick:2x alt='This is my alt' %}
{% asset src @magick:2x alt='This is my alt' %}
<img src="src" asset="@magick:2x" alt="This is my alt">
<img src="src" alt="This is my alt" asset>
```

## Defaults

We provide several defaults that get set when you run an asset, depending on content type, this could be anything from type, all the way to integrity.  *If there is a default attribute you do not wish to be included, you can disable the attribute with `!attribute`, and it will be skipped over.*

```liquid
{% asset img.png !integrity %}
{% asset bundle.css !type   %}
```

### Arguments

Our tags will take any number of arguments, and convert them to HTML, and even attach them to your output if the HTML processor you use accepts that kind of data.  ***This applies to anything but hashes, and arrays.*** So adding say, a class, or id, is as easy as doing `id="val"` inside of your tag arguments.

#### Built In

| Arg | Description | Type | Return Type |
|---|---|---|---|
| `@path` | Path | `*/*` | `text`
| `@data` | `data` URI | `*/*` | `text` |
| `@inline` | CSS `<style>` | `text/css` | `text/html` |
| | `text/svg+xml` XML | `image/svg+xml` | `text/svg+xml` |
| | JavaScript `<script>` | `application/javascript` | `text/html` |
| | Image `<img>` | `image/*` | `text/html` |
| `srcset` | [Responsive]() `<img>` | `image/*` | `text/html` |
| `srcset` + `@pic` | [Responsive]() `<pic>` | `image/*` | `text/html` |

*Jekyll Assets uses [@envygeeks](https://github.com/envygeeks) `liquid-tag-parser` which supports advanced arguments (hash based arguments) as well as array based arguments.  When you see something like `k1:sk1=val` it will get converted to `k1 = { sk1: "val" }` in Ruby.  To find out more about how we process tags you should visit the documentation for [`liquid-tag-parser`](https://github.com/envygeeks/liquid-tag-parser)*

#### Responsive Images

Jekyll Assets has the concept of responsive images, using the `picture` (when using `@pic` w/ `srcset`) and the `<img>` tag when using `srcset`. If you ship multiple `srcset` with your image, we will proxy, build and then ship out a `picture/img` tag with any number of `source/srcset`, and in the case of picture, with the original image being the `image`.

##### `<picture>` usage, requires `@pic`
###### Example

```liquid
{% asset img.png @pic
    srcset:max-width="200 2x"
    srcset:max-width="150 1.5x"
    srcset:max-width="100 1x"
      %}
```

```html
<picture>
  <source srcset="1.png 2x"   media="(max-width:200px)">
  <source srcset="2.png 1.5x" media="(max-width:150px)">
  <source srcset="3.png 1x"   media="(max-width:100px)">
  <img src="img.png">
</picture>
```

##### `<img>` usage
###### Example

```liquid
{% asset img.png
    srcset:width="200 2x"
    srcset:width="150 1.5x"
    srcset:width="100 1x"
      %}

{% asset img.svg
    srcset:width="200 2x jpg"
    srcset:width="150 1.5x jpg"
    srcset:width="100 1x jpg"
      %}

{% asset img.png
    srcset:width=200
    srcset:width=150
    srcset:width=200
      %}
```

```html
<img srcset="1.png 2x, 2.png 1.5x, 3.png 1x">
<img srcset="1.jpg 2x, 2.jpg 1.5x, 3.jpg 1x">
<img srcset="1.png 200w, 2.png 150w, 3.pnx 200w">
```

##### Args for `<img srcset>`

| Arg         | Type                  | Description                                      |
| ----------- | --------------------- | ------------------------------------------------ |
| `width`     | Width [Density, Type] | Resize, set `srcset="<Src> <<Width>px/Density>"` |


##### Args for `@pic`

| Arg         | Type            | Description                                  |
| ----------- | --------------- | -------------------------------------------- |
| `min-width` | Width [Density] | Resize, set `media="(min-width: <Width>px)"` |
| `max-width` | Width [Density] | Resize, set `media="(max-width: <Width>px)"` |
| `sizes`     | Any             | Your value, unaltered, unparsed.             |
| `media`     | Any             | Your value, unaltered, unparsed.             |

*If you set `media`, w/ `max-width`, `min-width`, we will not ship `media`, we will simply resize and assume you know what you're doing.  Our parser is not complex, and does not make a whole lot of assumptions on your behalf, it's simple and only meant to make your life easier.  In the future we may make it more advanced.*

## Liquid

We support liquid arguments for tag values (but not tag keys), and we also support Liquid pre-processing (with your Jekyll context) of most files if they end with `.liquid`.  This will also give you access to our filters as well as their filters, and Jekyll's filters, and any tags that are globally available.

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

```scss
.bg {
  background: url(asset_path("{{ site.background_image }}"));
}
```

You have full access to your entire global context from any liquid
processing we do.  Depending on where you do it, you might or might not also have access to your local (page) context as well. You can also do whatever you like, and be as dynamic as you like, including full loops, and conditional Liquid, since we pre-process your text files. *On Sprockets 4.x you can use `.liquid.ext` and `.ext.liquid`, but because of the way Sprockets 3.x works, we have opted to only allow the default extension of `.ext.liquid` when running on "Old Sprockets" (AKA 3.x.)  If you would like Syntax + Liquid you should opt to install Sprockets 4.x so you can get the more advanced features.*

#### Importing

***In order to import your Liquid pre-processed assets inside of Liquid or JS you should use a Sprockets `//require=`, Sprockets does not integrate that deeply into JavaScript and SASS to allow you to `@import` and pre-process.***

## `.sass`, `.scss` Helpers

We provide two base helpers, `asset_path` to return the path of an asset, and `asset_url` which will wrap `asset_path` into a `url()` for you, making it easy for you to extract your assets and their paths inside of SCSS.  All other helpers that Sprockets themselves provide will use our `asset_path` helper, so you can use them like normal, *including with Liquid*

```scss
body {
  background-image: asset_url("img.png");
}
```

### Proxies, and Other Arguments

Any argument that is supported by our regular tags, is also supported by our `.sass`/`.scss` helpers, with a few obvious exceptions (like `srcset`).  This means that you can wrap your assets into `magick` if you wish, or `imageoptim` or any other proxy that is able to spit out a path for you to use.  The general rule is, that if it returns a path, or `@data` then it's safe to use within `.scss`/`.sass`, otherwise it will probably throw.

```scss
body {
  background-image: asset_url("img.png @magick:half")
}
```

*Note: we do not validate your arguments, so if you send a conflicting argument that results in invalid CSS, you are responsible for that, in that if you ship us `srcset` we might or might not throw, depending on how the threads are ran. So it might ship HTML if you do it wrong, and it will break your CSS, this is by design so that if possible, in the future, we can allow more flexibility, or so that plugins can change based on arguments.*

## List

We provide all *your* assets as a hash of Liquid Drops so you can get basic info that we wish you to have access to without having to prepare the class. **Note:** The keys in the `assets` array are the names of the original files, e.g., use `*.scss` instead of `*.css`.

```liquid
{{ assets["bundle.css"].content_type }} => "text/css"
{{ assets["images.jpg"].width  }} => 62
{{ assets["images.jpg"].height }} => 62
```

The current list of available accessors:

| Method         | Description                             |
| -------------- | --------------------------------------- |
| `content_type` | The RFC content type                    |
| `height`       | The asset height ***(if available)***   |
| `filename`     | The full path to the assets actual file |
| `width`        | The asset width ***(if available)***    |
| `digest_path`  | The prefixed path                       |
| `integrity`    | The SRI hash (currently sha256)         |

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
{{ src | asset:"@magick:2x magick:quality=92" }}
```

## Polymer WebComponents

We have basic support for WebComponents when using Sprockets `~> 4.0.0.beta`, this will allow you to place your HTML in the `_assets/components` folder, `{% asset myComponent.html %}`, and get an import, you can place your regular JS files inside of the normal structure.

### Example

***test.html***

```html
<!DOCTYPE html>
<html>
  <head>
    {% asset webcomponents.js %}
    {% asset test.html %}
  </head>
  <body>
    <contact-card starred>
      {% asset profile.jpg %}
      <span>Your Name</span>
    </contact-card>
  </body>
</body>
```

***_assets/components/test.html***

```html
<dom-module id="contact-card">
  <template>
    <style>/* ... */</style>
    <slot></slot>
    <iron-icon icon="star" hidden$="{{!starred}}"></iron-icon>
  </template>
  <script>
    class ContactCard extends Polymer.Element {
      static get is() { return "contact-card"; }
      static get properties() {
        return {
          starred: { type: Boolean, value: false }
        }
      }
    }
    customElements.define(ContactCard.is, ContactCard);
  </script>
</dom-module>
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

Your plugin can also register it's own hooks on our Hook system, so that you can trigger hooks around your stuff as well, this is useful for extensive plugins that want more power.

```ruby
Jekyll::Assets::Hook.add_point(:plugin, :hook)
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

Once crass is added, we will detect vendor prefixes, and add `/* @alternate */` to them, with or without compression enabled, and with protections against compression stripping.

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
gem "boostrap-sass" # 3.x
gem "bootstrap"     # 4.x
```

```scss
@import 'bootstrap'
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
| `magick:flip`               | ✔             |
| `magick:background`         | ✔             |
| `magick:transparency`       | ✔             |
| `@magick:double`            | ✗             |
| `@magick:half`              | ✗             |

<sup>\*</sup> *`magick:format` requires an ext or a valid MIME content type like `image/jpeg` or `.jpg`.  We will `ImageMagick -format` on your behalf with that information by getting the extension.*

### ImageOptim

```ruby
gem "image_optim"
gem "image_optim_bin" # Optional
```

#### Configuration

```yml
assets:
  plugins:
    img:
      optim:
        {}
```

Check the [ImageOptim](https://github.com/toy/image_optim#configuration) to get idea about configuration options, and to get a list of stuff you need to install on your system to use it, if you do not wish to use "image_optim_bin",

#### Args

| Name                              | Accepts Value |
| --------------------------------- | ------------- |
| `optim`                           | ✔             |
| `@optim`                          | ✗             |

***By default `@optim` will use the default `jekyll`, otherwise you can provide `optim=preset` and have it used that preset.  ImageOptim provides advanced, and default as their default presets, you can define your own preset via Jekyll Assets configuration listed above.***

### Building Your Own Plugins
#### Globals

| Name      | Class                   |
| --------- | ----------------------- |
| `@env`    | `Jekyll::Assets::Env`   |
| `@args`   | `Liquid::Tag::Parser{}` |
| `@jekyll` | `Jekyll::Site`          |
| `@asset`  | `Sprockets::Asset`      |

#### HTML

| Name   | Class                      | Type            |
| ------ | -------------------------- | --------------- |
| `@doc` | `Nokogiri:: XML::Document` | `image/svg+xml` |
| `@doc` | `Nokogiri::HTML::Document` | `image/*`       |

## Migrating from Earlier Versions
### Configuration

*Before*

```yaml
cdn: https://example.com
```

*After*

```yaml
cdn:
  url: https://example.com
```

### Images/CSS/JS

*Before*

```liquid
{% css css.css %}
{% img image.jpg width:60 class:image %}
{% js js.js %}
```

*After*

```liquid
{% asset css.css %}
{% asset image.jpg width=60 class=image %}
{% asset js.js %}
```

### Custom Tags

*Before*

```liquid
<link rel="apple-touch-icon-precomposed" href="{% asset_path icon.png %}">
<link rel="apple-touch-icon-precomposed" href="{% asset_data icon.png %}">
```

*After*

```liquid
<link rel="apple-touch-icon-precomposed" href="{% asset icon.png @path %}">
<link rel="apple-touch-icon-precomposed" href="{% asset icon.png @data %}">
```
