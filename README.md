<p align=center>
  <a href=https://goo.gl/BhrgjW>
    <img src=https://envygeeks.io/badges/paypal-large_1.png alt=Donate>
  </a>
  <br>
  <a href=https://travis-ci.org/jekyll/jekyll-assets>
    <img src="https://travis-ci.org/jekyll/jekyll-assets.svg?branch=master" alt=Status>
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
assets:
  prefix: "/assets"
  autowrite: true
  cache:
    path: .jekyll-cache/assets
    type: file|memory|false|null|nil
    enabled: true
  cdn:
    baseurl: true|false
    url: https://cdn.example.com
    prefix: true|false
  precompile:
  - "bundle.css"
  sources:
  - _assets/css
  - _assets/images
  - _assets/javascripts
  - _assets/stylesheets
  - _assets/fonts
  - _assets/img
  - _assets/js
  plugins:
    compression:
      css: false
       js: false
    img:
      defaults:
        dimensions: true|false
        alt: true|false
      optim:
        #
```

## Tutorials
### From Jekyll to Jekyll Assets

The following section shows how to get started with the generation of CSS, using Jekyll Assets. It applies to a newly generated Jekyll site (`jekyll new`,) however this should help anyone who has a Jekyll site. It should also be applicable for other types of assets.

#### Create the `_assets/{css,js,img,font}` directories

The default [Jekyll Assets configuration](#configuration) expects to find all the assets in directories under `_assets`. Create a directory for the CSS:

```bash
mkdir -p _assets/css
mkdir -p _assets/font
mkdir -p _assets/img
mkdir -p _assets/js
```

#### Move your CSS files

Jekyll comes with a `css` directory containing a `main.css` file and then a `_sass` directory with a few SASS imports. Move all of that to the `_assets/css` directory.

```bash
mv css/main.css _assets/css
mv _sass/* _assets/css
```

#### Update the layout

The layout will no longer be pointing to the correct `main.css` file. Jekyll Assets supplies [liquid tags](#tags) to generate the correct HTML for these assets. Open `_includes/head.html` and replace the `<link>` to the CSS with:

```liquid
{% css main.css %}
```

Start up your local Jekyll server and if everything is correct, your site will be serving CSS via Sprockets. Read on for more information on how to customize your Jekyll Assets setup.

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
@import 'bootstrap-sprockets'
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

* `magick:resize=<value>`
* `magick:format=<value>`
* `magick:quality=<value>`
* `magick:rotate=<value>`
* `magick:gravity=<value>`
* `magick:crop=<value>`
* `magick:flip=<value>`
* `@magick:quadruple`, `@magick:4x`
* `@magick:one-third`, `@magick:1/3`
* `@magick:three-fourths`, `@magick:3/4`
* `@magick:two-fourths`, `@magick:2/4`
* `@magick:two-thirds`, `@magick:2/3`
* `@magick:one-fourth`, `@magick:1/4`
* `@magick:half`, `@magick:1/2`

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

* `image_optim:preset:<name>`
* `image_optim:preset:default`
* `image_optim:default`

### Less
#### Installation

```ruby
gem "less"
```

## Tags

* `image`, `img`
* `javascript`, `js`
* `stylesheet`, `css`, `style`
* `asset`, `asset_source`
* `asset_path`

### Tag Example:

```liquid
{% img src @magick:2x alt='This is my alt' %}
{% img src @magick:2x alt='This is my alt' %}
```

### What do the colons mean?

Jekyll Assets uses [@envygeeks](https://github.com/envygeeks) `liquid-tag-parser` which supports advanced arguments (hash based arguments) as well as array based arguments.  When you see something like `k1:sk1=val` it will get converted to `k1 = { sk1: "val" }` in Ruby.  To find out more about how we process tags you should visit the documentation for [`liquid-tag-parser`](https://github.com/envygeeks/liquid-tag-parser)

## Liquid Variables

We support liquid arguments for tag values (but not tag keys), and we also support Liquid pre-processing (with your Jekyll context) sass/less/css files you need do nothing special for the preprocessing an entire file, it's always done.

An example of using Liquid in your tags:

```liquid
{% img '{{ image_path }}' %}
{% img '{{ image_path }}' proxy:key='{{ value }}' %}
{% img {{\ image_path\ }} %}
```

An example of using Liquid in your SCSS:

```scss
.bg {
  background: url(asset_path("{{ site.background_image }}"));
}
```

You have full access to your entire Jekyll context from any liquid
processing we do, so you can do whatever you like and be as dynamic as you like, including full loops and conditional Liquid based CSS since we pre-process your text files.

## Accessing Asset Info

We provide all *your* assets as a hash of Liquid Drops so you can get basic info that we wish you to have access to without having to prepare the class.

```liquid
{{ assets["bundle.css"].content_type }} => "text/css"
{{ assets["images.jpg"].width  }} => 62
{{ assets["images.jpg"].height }} => 62
```

The current list of available accessors:

* `logical_path`
* `content_type`
* `filename`
* `basename`
* `width`
* `height`
* `digest_path`

If you would like more, please feel free to add a pull request, at this
time we will reject all pull requests that wish to add any digested paths as those are dynamically created when a proxy is ran so we can never predict it reliably unless we proxy and that would be a performance problem.

## Tips
### Dynamic Assets

Using Liquid Drop `assets`, you can check whether an asset is present.

```liquid
{% if assets[page.image] %}{% img '{{ page.image }}' %}
{% else %}
  {% img default.jpg %}
{% endif %}
```

## Filters

Any tag can be a filter

```liquid
{{ src | img:"@magick:2x magick:quality:92" }}
```

### Multi

Jekyll Assets has a special called `jekyll_asset_multi` which is meant to be used for things like the header, where it would be nice to be able to include multiple assets at once.  You can use it like so:

```liquid
{{ '"css bundle.css" "js bundle.js async=true"' | jekyll_asset_multi }}
```

## Hooks

* `:env` => `:init`

You can register like so:

```ruby
Jekyll::Assets::Hook.register :env, :init do
  # Your Work
end
```

## Having trouble with our documentation?

If you do not understand something in our documentation please feel
free to file a ticket and it will be explained and the documentation updated, however... if you have already figured out the problem please feel free to submit a pull request with clarification in the documentation and we'll happily work with you on updating it.
