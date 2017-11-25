[![Code Climate](https://img.shields.io/codeclimate/maintainability/envygeeks/jekyll-assets.svg?style=for-the-badge)](https://codeclimate.com/github/envygeeks/jekyll-assets/maintainability) [![Code Climate](https://img.shields.io/codeclimate/coverage/github/envygeeks/jekyll-assets.svg?style=for-the-badge)](https://codeclimate.com/github/envygeeks/jekyll-assets/test_coverage) [![Travis branch](https://img.shields.io/travis/envygeeks/jekyll-assets/master.svg?style=for-the-badge)](https://travis-ci.org/envygeeks/jekyll-assets) [![Donate](https://img.shields.io/badge/DONATE-USD-green.svg?style=for-the-badge)](https://envygeeks.io#donate) [![Gem](https://img.shields.io/gem/v/jekyll-assets.svg?style=for-the-badge)]()

# Jekyll Assets

Jekyll Assets is a drop in [asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) that uses [Sprockets](https://github.com/rails/sprockets) to build specifically for Jekyll. It utilizes [Sprockets](https://github.com/rails/sprockets), and [Jekyll](https://jekyllrb.com) to try and achieve a clean and extensible assets platform that supports plugins, caching, converting your assets, and even the proxy of said assets in a way that does not interfere with either [Sprockets](https://github.com/rails/sprockets), or [Jekyll](3), and your own source.  By default you can add Jekyll Assets to your Gemfile, as a plugin, and have it act as a drop-in replacement for Jekyll's basic SASS/CoffeeScript processors, with you only having to add it to your Gemfile, and updating your `<img>`, and `<link>`.

## Using Jekyll Assets with Jekyll

```ruby
gem "jekyll-assets", group: :jekyll_plugins
gem "jekyll-assets", git: "https://github.com/envygeeks/jekyll-assets", group: :jekyll_plugins
gem "jekyll-assets", "~> x.x.alpha", group: :jekyll_plugins
```

### Requirments

* Ruby ***2.3+***
* Jekyll ***3.5+***
* Sprockets ***3.3+***

***If you would like SourceMap support, or faster Sprockets, you should prefer to use Sprockets "~> 4.0.beta", we support SourceMaps in this version of Sprockets because it supports them. It's manifest an other features are also much better inside of this version of Sprockets.***

```ruby
gem "sprockets", "~> 4.0.beta", {
  require: false
}
```

## Configuration

The configuration file is the same as Jekyll's, which is `_config.yml`. Except we use the special key "assets" inside of that file.  Any environment variable noted as "val on `JEKYLL_ENV`" is only overridden when not explicitly set.  All values listed below are default, you need not copy these into your configuration file unless you plan to change a value.

```yaml
digest: false
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
precompile: []
cdn:
  baseurl: false
  destination: false
  url: null
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

## Tag
### Usage
#### Liquid

```liquid
{% asset src @magick:2x alt='This is my alt' %}
{% asset src @magick:2x alt='This is my alt' %}
```

#### HTML

```html
<img src="src" asset="@magick:2x" alt="This is my alt">
<img src="src" alt="This is my alt" asset>
```

### Defaults

We provide several defaults that get set when you run an asset, depending on content type, this could be anything from type, all the way to integrity.  If there is a default attribute you do not wish to be included, you can disable the attribute with `!attribute`, and it will be skipped over.

#### Usage

```liquid
{% asset img.png !integrity %}
{% asset bundle.css !type   %}
```

### Arguments

Our tags will take any number of arguments, and convert them to HTML, and even attach them to your output if the HTML processor you use accepts that kind of data.  ***This applies to anything but hashes, and arrays.*** So adding say, a class, or id, is as easy as doing `id="val"` inside of your tag arguments.

#### Builtins

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

***Jekyll Assets uses [@envygeeks](https://github.com/envygeeks) `liquid-tag-parser` which supports advanced arguments (hash based arguments) as well as array based arguments.  When you see something like `k1:sk1=val` it will get converted to `k1 = { sk1: "val" }` in Ruby.  To find out more about how we process tags you should visit the documentation for [`liquid-tag-parser`](https://github.com/envygeeks/liquid-tag-parser)***

#### Responsive Images

Jekyll Assets has the concept of responsive images, using the `picture` (when using `@pic` w/ `srcset`) and the `<img>` tag when using `srcset`. If you ship multiple `srcset` with your image, we will proxy, build and then ship out a `picture/img` tag with any number of `source/srcset`, and in the case of picture, with the original image being the `image`.

##### `<picture>` usage, requires `@pic`
###### Example

```liquid
{% asset img.png @pic
    srcset:max-width="800 2x"
    srcset:max-width="600 1.5x"
    srcset:max-width="400 1x"
      %}
```

```html
<picture>
  <source srcset="1.png 2x"   media="(max-width:800px)">
  <source srcset="2.png 1.5x" media="(max-width:600px)">
  <source srcset="3.png 1x"   media="(max-width:400px)">
  <img src="img.png">
</picture>
```

##### `<img>` usage
###### Example

```liquid
{% asset img.png
    srcset:width="400 2x"
    srcset:width="600 1.5x"
    srcset:width="800 1x"
      %}

{% asset img.png
    srcset:width=400
    srcset:width=600
    srcset:width=800
      %}
```

```html
<img srcset="1.png   2x, 2.png 1.5x, 3.png   1x">
<img srcset="1.png 400w, 2.png 600w, 3.pnx 800w">
```

##### Args

| Arg | Type | Description | `@pic` Only |
| --- | ---- | ------------| ----------- |
| `width`     | Width [Density] | Resize, set `srcset="<Src> <<Width>px/Density>"` | ✗ |
| `min-width` | Width [Density] | Resize, set `media="(min-width: <Width>px)"` | ✔ |
| `max-width` | Width [Density] | Resize, set `media="(max-width: <Width>px)"` | ✔ |
| `sizes`     | Any | Your value, unaltered, unparsed. | ✗ |
| `media`     | Any | Your value, unaltered, unparsed. | ✗ |

***If you set `media`, w/ `max-width`, `min-width`, we will not ship `media`, we will simply resize and assume you know what you're doing.  Our parser is not complex, and does not make a whole lot of assumptions on your behalf, it's simple and only meant to make your life easier.  In the future we may make it more advanced.***

## Liquid

We support liquid arguments for tag values (but not tag keys), and we also support Liquid pre-processing (with your Jekyll context) of most files if they end with `.liquid`.  This will also give you access to our filters as well as their filters, and Jekyll's filters.

### Usage

```liquid
{% img '{{ image_path }}' %}
{% img '{{ image_path }}' proxy:key='{{ value }}' %}
{% img {{\ image_path\ }} %}
```

#### `.liquid.ext`, and `.ext.liquid`

```scss
.bg {
  background: url(asset_path("{{ site.background_image }}"));
}
```

You have full access to your entire Jekyll context from any liquid
processing we do, so you can do whatever you like, and be as dynamic as you like, including full loops, and conditional Liquid based CSS/JavaScript since we pre-process your text files. ***On Sprockets 4.x you can use `.liquid.ext` and `.ext.liquid`, but because of the way Sprockets 3.x works, we have opted to only allow the default extension of `.ext.liquid` when running on "Old Sprockets" (AKA 3.x.)  If you would like Syntax + Liquid you should opt to install Sprockets 4.x so you can get the more advanced features.***

##### Importing

***In order to import your Liquid pre-processed assets inside of Liquid or JS you should use a Sprockets `//require=`, Sprockets does not integrate that deeply into JavaScript and SASS to allow you to `@import` and pre-process.***

## Sass/SCSS Helpers

We provide two helpers, `asset_path` to return the path of an asset, and `asset_url` which will wrap `asset_path` into a `url()` for you, making it easy for you to extract your assets and their paths inside of SCSS.

### Usage

```scss
body {
  background-image: asset_url("img.png");
}
```

#### Proxies, and Other Arguments

Any argument that is supported by our regular tags, is also supported by our Sass/SCSS helpers, with a few obvious exceptions (like `srcset`).  This means that you can wrap your assets into `magick` if you wish, or `imageoptim` or any other proxy that is able to spit out a path for you to use.

##### Usage

```scss
body {
  background-image: asset_url("img.png @magick:half")
}
```

***Not we do not validate your arguments, so if you send a conflicting argument that results in invalid CSS, you are responsible for that, in that if you ship us `srcset` we won't throw, we will spit out HTML for you, and it will break your CSS, this is by design.***

## List

We provide all *your* assets as a hash of Liquid Drops so you can get basic info that we wish you to have access to without having to prepare the class.

```liquid
{{ assets["bundle.css"].content_type }} => "text/css"
{{ assets["images.jpg"].width  }} => 62
{{ assets["images.jpg"].height }} => 62
```

The current list of available accessors:

| Method | Description |
|---|---|
| `content_type` | The RFC content type |
| `height` | The asset height ***(if available)*** |
| `filename` | The full path to the assets actual file |
| `width` | The asset width ***(if available)*** |
| `digest_path` | The prefixed path |

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
{{ src | asset:"@magick:2x magick:quality:92" }}
```

## Hooks

| Point | Name | Instance | Args |
|---|---|---|---|
| `:env` | `:before_init` | ✔ | ✗ |
| `:env` | `:after_init` | ✔ | ✗ |
| `:config` | `:before_merge` | ✗ | `Config{}` |
| `asset` | `:before_compile` | ✗ | `Asset`, `Manifest` |

### Usage

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

##### Usage

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
### Font Awesome
#### Installation

```ruby
gem "font-awesome-sass"
```

#### Usage

```scss
@import "font-awesome-sprockets"
@import "font-awesome"
```

### CSS Auto-Prefixing
#### Installation

```ruby
gem "autoprefixer-rails"
```

#### Config

```yml
assets:
  autoprefixer:
    browsers:
    - "last 2 versions"
    - "IE > 9"
```

### Bootstrap
#### Installation

***4.x***
```ruby
gem "bootstrap"
```

***3.x***
```ruby
gem "boostrap-sass"
```

#### Usage

```scss
@import 'bootstrap'
```

### ImageMagick
#### Installation

```ruby
gem "mini_magick"
```

#### Tag Args

See the [MiniMagick docs](https://github.com/minimagick/minimagick#usage)
to get an idea what `<value>` can be.

| Name | Accepts Value |
|---|---|
| `magick:compress` | ✔ |
| `magick:resize` | ✔ |
| `magick:format`<sup>*</sup> | ✔ |
| `magick:quality` | ✔ |
| `magick:rotate` | ✔ |
| `magick:gravity` | ✔ |
| `magick:crop` | ✔ |
| `magick:flip` | ✔ |
| `@magick:double` | ✗ |
| `@magick:half` | ✗ |

<sup>\*</sup> ***`magick:format` requires an ext or a valid MIME content type like `image/jpeg` or `.jpg`.  We will `ImageMagick -format` on your behalf with that information by getting the extension.***

### ImageOptim
#### Installation

```ruby
gem "image_optim"
```

#### Config

  Check the [ImageOptim](https://github.com/toy/image_optim#configuration) to get idea about configuration options.

```yml
assets:
  plugins:
    img:
      optim:
        default:
          verbose: true
        zero_png:
          advpng:
            level: 0
          optipng:
            level: 0
          pngout:
            strategy: 4
```

#### Tag Args

| Name | Accepts Value |
|---|---|
| `@image_optim:preset`<sup>*</sup> | ✗ |

<sup>\*</sup>***Where `preset` is the name of the preset.***

### Building Your Own Plugins
#### Global Instance Vars

| Name | Class |
|---|---|
| `@env` | `Jekyll::Assets::Env` |
| `@args` | `Liquid::Tag::Parser{}` |
| `@jekyll` | `Jekyll::Site` |
| `@asset` | `Sprockets::Asset` |

##### HTML Instance Vars

| Name | Class | Type |
|---|---|---|
| `@doc` | `Nokogiri:: XML::Document` | `image/svg+xml` |
| `@doc` | `Nokogiri::HTML::Document` | `image/*` |
