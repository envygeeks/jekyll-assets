<p align=center>
  <a href=https://goo.gl/BhrgjW>
    <img src=https://envygeeks.io/badges/paypal-large_1.png>
  </a>
  <br>
  <a href=https://travis-ci.org/jekyll/jekyll-assets>
    <img src="https://travis-ci.org/jekyll/jekyll-assets.svg?branch=master" alt=Status>
  </a>
  <a href=https://codeclimate.com/github/codeclimate/codeclimate/coverage>
    <img src=https://codeclimate.com/github/codeclimate/codeclimate/badges/coverage.svg />
  </a>
  <a href=https://codeclimate.com/github/codeclimate/codeclimate>
    <img src=https://codeclimate.com/github/codeclimate/codeclimate/badges/gpa.svg />
  </a>
</p>

[1]:http://guides.rubyonrails.org/asset_pipeline.html
[2]:https://github.com/rails/sprockets
[3]:https://jekyllrb.com

# Jekyll Assets

Jekyll assets is an [asset pipeline][1] that uses [Sprockets][2] to build specifically for Jekyll. It utilizes [Sprockets][2], and [Jekyll][3] to try and achieve a clean and extensible assets platform that supports plugins, caching, converting your assets, and even the proxy of said assets in a way that does not interfere with either [Sprockets][2], or [Jekyll][3], and your own source.

## Using Jekyll Assets with Jekyll

```ruby
# Gemfile
gem "jekyll-assets", {
  group: :jekyll_plugins
}
```

## Configuration

The configuration file is the same as Jekyll's, which is `_config.yml`. Except we use the special key "assets" inside of that file.

```yaml
liquid: false
prefix: "/assets"
integrity: false
autowrite: true
digest: false
strict: false
caching:
  enabled: true
  path: ".jekyll-cache/assets"
  type: file
precompile: []
cdn:
  baseurl: false
  prefix: false
plugins:
  img:
    optim: {}
  compression:
    js:
      enabled: false
      opts: {}
    css:
      enabled: true
sources:
- _assets/css
- _assets/fonts
- _assets/img
- _assets/js
- _assets/css
- _assets/fonts
- _assets/img
- _assets/js
```

## Tag
### Usage

```liquid
{% asset src @magick:2x alt='This is my alt' %}
{% asset src @magick:2x alt='This is my alt' %}
```

### Arguments

Our tags will take any number of arguments, and convert them to HTML, and even attach them to your output if the HTML processor you use accepts that kind of data.  ***This applies to anything but hashes, and arrays.*** So adding say, a class, or id, is as easy as doing `id="val"` inside of your tag arguments.

#### Builtin

| Arg | Description |
|---|---|
| `@path` | Return just the path |
| `@data-uri` | Return a data URI instead of HTML |
| `@source` | Return the source |

***Jekyll Assets uses [@envygeeks](https://github.com/envygeeks) `liquid-tag-parser` which supports advanced arguments (hash based arguments) as well as array based arguments.  When you see something like `k1:sk1=val` it will get converted to `k1 = { sk1: "val" }` in Ruby.  To find out more about how we process tags you should visit the documentation for [`liquid-tag-parser`](https://github.com/envygeeks/liquid-tag-parser)***

## Liquid

We support liquid arguments for tag values (but not tag keys), and we also support Liquid pre-processing (with your Jekyll context) of most files if they end with `.liquid`.  This will also give you access to our filters as well as their filters, and Jekyll's filters.

### Usage

```liquid
{% img '{{ image_path }}' %}
{% img '{{ image_path }}' proxy:key='{{ value }}' %}
{% img {{\ image_path\ }} %}
```

#### `.liquid`

```scss
.bg {
  background: url(asset_path("{{ site.background_image }}"));
}
```

You have full access to your entire Jekyll context from any liquid
processing we do, so you can do whatever you like and be as dynamic as you like, including full loops and conditional Liquid based CSS since we pre-process your text files.

##### Importing

In order to import your Liquid pre-processed assets inside of Liquid or JS you should use a Sprockets `//require=`, Sprockets does not integrate that deeply into JavaScript and SASS to allow you to `@import` and pre-process.

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
| `logical_path` | The filename |
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
| `:env` | `:init` | ✔ | ✗ |
| `:config` | `:pre` | ✗ | `Config{}` |

### Usage

```ruby
Jekyll::Assets::Hook.register :env, :init do
  append_path "myPluginsCustomPath"
end
```

```ruby
Jekyll::Assets::Hook.register :config, :pre do |c|
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

```ruby
gem "bootstrap-sass"
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
|---| --- |
| `magick:compress` | ✔ |
| `magick:resize` | ✔ |
| `magick:format` | ✔ |
| `magick:quality` | ✔ |
| `magick:rotate` | ✔ |
| `magick:gravity` | ✔ |
| `magick:crop` | ✔ |
| `magick:flip` | ✔ |
| `@magick:double` | ✗ |
| `@magick:half` | ✗ |

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

## Tutorials
### Jekyll to Jekyll Assets

The following section shows how to get started with the generation of CSS, using Jekyll Assets. It applies to a newly generated Jekyll site (`jekyll new`,) however this should help anyone who has a Jekyll site. It should also be applicable for other types of assets.

#### Create

The default [Jekyll Assets configuration](#configuration) expects to find all the assets in directories under `_assets`. Create a directory for the CSS:

```bash
mkdir -p _assets/css
mkdir -p _assets/font
mkdir -p _assets/img
mkdir -p _assets/js
```

#### Move

Jekyll comes with a `css` directory containing a `main.css` file and then a `_sass` directory with a few SASS imports. Move all of that to the `_assets/css` directory.

```bash
mv css/main.css _assets/css
mv _sass/* _assets/css
```

#### Update

The layout will no longer be pointing to the correct `main.css` file. Jekyll Assets supplies [liquid tags](#tags) to generate the correct HTML for these assets. Open `_includes/head.html` and replace the `<link>` to the CSS with:

```liquid
{% asset main.css %}
```

Start up your local Jekyll server and if everything is correct, your site will be serving CSS via Sprockets. Read on for more information on how to customize your Jekyll Assets setup.

### Building Your Own Plugins
#### Global Instance Vars

| Name | Class |
|---|---|
| `@env` | `Jekyll::Assets::Env` |
| `@args` | `Liquid::Tag::Parser{}` |
| `@jekyll` | `Jekyll::Site` |
| `@asset` | `Sprockets::Asset` |

## Having trouble with our documentation?

If you do not understand something in our documentation please feel
free to file a ticket and it will be explained and the documentation updated, however... if you have already figured out the problem please feel free to submit a pull request with clarification in the documentation and we'll happily work with you on updating it.
