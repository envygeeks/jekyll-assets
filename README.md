# Jekyll::AssetsPlugin

[![Gem Version](https://badge.fury.io/rb/jekyll-assets.png)](http://badge.fury.io/rb/jekyll-assets)
[![Build Status](https://secure.travis-ci.org/ixti/jekyll-assets.png)](http://travis-ci.org/ixti/jekyll-assets)
[![Dependency Status](https://gemnasium.com/ixti/jekyll-assets.png)](https://gemnasium.com/ixti/jekyll-assets)
[![Code Climate](https://codeclimate.com/github/ixti/jekyll-assets.png)](https://codeclimate.com/github/ixti/jekyll-assets)
[![Coverage Status](https://coveralls.io/repos/ixti/jekyll-assets/badge.png)](https://coveralls.io/r/ixti/jekyll-assets)

Jekyll plugin, that adds Rails-alike assets pipeline, that means that:

- It allows you to write javascript/css assets in other languages such as
  CoffeeScript, Sass, Less and ERB.
- It allows you to specify dependencies between your assets and automatically
  concatenates them.
- It allows you to minify/compress your JavaScript and CSS assets using
  compressor you like: YUI, SASS, Uglifier or no compression at all.
- It supports JavaScript templates for client-side rendering of strings or
  markup. JavaScript templates have the special format extension `.jst` and are
  compiled to JavaScript functions.
- Adds MD5 fingerprint suffix for _cache busting_. That means your `app.css`
  will become `app-908e25f4bf641868d8683022a5b62f54.css`. See `cachebust`
  configuration option for other variants.
- Produce gzipped versions of assets. See `gzip` configuration option for
  details.
- [Compass][compass], [Bourbon][bourbon] and [Neat][neat] built-in support.
  See "Custom Vendors" below.
- [Autoprefixer][autoprefixer] support

[compass]:      http://compass-style.org/
[bourbon]:      http://bourbon.io/
[neat]:         http://neat.bourbon.io/
[autoprefixer]: https://github.com/postcss/autoprefixer

Jekyll-Assets uses fabulous [Sprockets][sprockets] under the hood, so you may
refer to Rails guide about [Asset Pipeline][rails-guide] for detailed
information about amazing features it gives you.

*Note:* You must have an [ExecJS][extjs] supported runtime in order to use
  CoffeeScript.


[rails-guide]:  http://guides.rubyonrails.org/asset_pipeline.html
[sprockets]:    https://github.com/sstephenson/sprockets#readme
[extjs]:        https://github.com/sstephenson/execjs#readme

For a quick start check out [jekyll-assets introduction][jekyll-assets-intro]
that shows how to use it step by step. Also you might want to take a look on
[my blog sources][ixti-blog-src] as a real-world example as well.

[jekyll-assets-intro]:  http://ixti.net/software/2012/12/30/unleash-mr-hyde-introduction-of-jekyll-assets.html
[ixti-blog-src]:        https://github.com/ixti/ixti.github.com


## Installation

Add this line to your application's Gemfile:

    gem 'jekyll-assets'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-assets


## How to Use Jekyll-Assets

First of all make sure to require it. Common practice is to add following line
into `_plugins/ext.rb` file:

``` ruby
require "jekyll-assets"
```

Once plugin installed, you'll have following Liquid tags available:

- `{% javascript app %}`: Generates `<script>` tag for `app.js`
- `{% stylesheet app %}`: Generates `<link>` tag for `app.css`
- `{% image logo.png %}`: Generates `<img>` tag for `logo.png`
- `{% asset_path logo.png %}`: Returns _resulting_ URL for `logo.png`
- `{% asset app.css %}`: Returns _compiled_ body of `app.css`

Also you'll have complimentary Liquid filters as well:

- `{{ 'app' | javascript }}`: Generates `<script>` tag for `app.js`
- `{{ 'app' | stylesheet }}`: Generates `<link>` tag for `app.css`
- `{{ 'logo.png' | image }}`: Generates `<img>` tag for `logo.png`
- `{{ 'logo.png' | asset_path }}`: Returns _resulting_ URL for `logo.png`
- `{{ 'app.css' | asset }}`: Returns _compiled_ body of `app.css`

Filters are used mostly to render tag (or asset source) using variable that
holds value of asset logical path rather than specifiyng it directly. Here's
an example that speaks for itself:

```
{% if page.custom_css %}{{ page.custom_css | stylesheet }}{% endif %}
```

All compiled assets will be stored under `assets/` dir of generated site.

Pipeline assets should be under your sources directory of Jekyll site. When a
file is referenced with liquid tag or with helper from another asset, Sprockets
searches the three default asset locations for it: `_assets/images`,
`_assets/javascripts` and `_assets/stylesheets`.

For example these files:

```
_assets/stylesheets/app.css
_assets/javascripts/app.js
_assets/javascripts/vendor/jquery.js
```

would be referenced like this:

``` html
{% stylesheet app %}
{% javascript app %}
{% javascript vendor/jquery %}
```

You might want to require `vendor/jquery.js` into your `app.js`. To do so, just
put following line in the beginning of your `app.js` to get it concatenated:

``` javascript
//= require vendor/jquery

$(function () {
  alert('I love BIG BOOKS!');
});
```

If you want to use CoffeScript, just add `.coffee` suffix to the file you want
and you're good to go. For example, here's how your `app.js.coffe` might look
like:

``` coffeescript
#= require vendor/jquery

$ ->
  alert 'I love BIG BOOKS! And small ones too!'
```

Notice, that `vendor/jquery` is not required to be coffee script. You can easily
mix CoffeeScript and vanilla JavaScript, CSS and SCSS and SASS and LESS. The
difference is only in comments styles used with _directives_.

See detailed information about these _directives_ below.

You might also want your stylesheets and javascripts to be minified. In this
case just install the `uglifier` gem and any other gems you will be using, e.g.
`sass`, `coffee-script`. Then add following lines into your `config.yml`:

``` yaml
assets:
  js_compressor:  uglifier
  css_compressor: sass
```

If you want to use YUI compressor for minification, install `yui-compressor`
gem and put `yui` in place of `uglifier` and/or `sass` in the config file.
You can also define and use your own compressor, see "Custom Compressors".

Let's go crazy now! Assume you want your blog's `body` background color to be
white all the time, but red if you compiled your web-site in December. Just add
`.erb` suffix extension and you can use ruby in your asset like this:

```
// file: _assets/stylesheets/app.css.sass.erb

body
  background-color: <%= (12 == Date.today.month) ? "red" : "white" %>
```

Want more? Sure, here you are. You can use JavaScript templating with EJS or ECO
for example. Create a file `_assets/javascripts/hello.jst.ejs` with following
contents:

``` html
<p>Hello, <span><%= name %></span>!</p>
<p><%= info %></p>
```

Then use it in your `app.js` file like this:

``` coffeescript
#= require vendor/jquery
#= require hello

$ ->
  $("body").html JST["hello"]
    name: "ixti"
    info: "I love BIG BOOKS! And small ones too!"
```

Finally, you might want to store your assets on [Amazon S3][amazon-s3] or any
CDN service you like. As said previously, all compiled/processed assets got
special MD5 checksum appended to their original filenames. So, for example,
your `app.js.coffee` will become something like:

    app-4f41243847da693a4f356c0486114bc6.js

By default, generated URLs will have `/assets/` prefixes, but you will want to
change this if you are going to host assets somewhere else. This can be easily
changed via configuration:

``` yaml
assets:
  baseurl: http://my.super-cool-cdn.com/assets
```

[amazon-s3]: http://aws.amazon.com/s3


### Custom Compressors

Sprockets comes with good set of preconfigured compressors, but imagine you are
not satisfied with default settings. For example you want to strip all comments
but copyrights info. In this case you can define and use your own compressor.

To do so, first let's define new compressor in `_plugins/ext.rb`:

``` ruby
require "jekyll-assets"
require "sprockets"

Sprockets.register_compressor 'application/javascript',
  :my_uglifier, Uglifier.new(:comments => :copyright)
```

Once it's done, just tell assets to use `my_uglifier` as js compressor:

``` yaml
assets:
  js_compressor: my_uglifier
```


### Compilation Cache

To improve build time, you can enabled compiled assets cache:

``` yaml
assets:
  cache: true
```

This will keep cache of compiled assets in `.jekyll-assets-cache` under source
of your jekyl site. If you want to use different location specify it instead of
`true`, in this case it should be an absolute path or path relative to source
path of your jekyl site.


## Custom Vendors

Sometimes you would like to have some 3rd-party vendors. For this purposes,
normally all you have to do is to override default assets sources in config:

``` yaml
assets:
  sources:
    - _assets/images
    - _assets/javascripts
    - _assets/stylesheets
    - _vendors/bootstrap/stylesheets
    - _vendors/bootstrap/javascripts
```

But sometimes this is not enough. For example, with compass. As jekyll-assets
uses Sprockets internally, you can simply append "global" paths into it. Just
add following line into your `_plugins/ext.rb` file:

``` ruby
require "sprockets"

Sprockets.append_path "/my/vendor"
```

That's it, now jekyll-assets will try to look for assets inside `/my/vendor`
path first.


### Built-in Vendors Support

For your comfort jekyll-assets has built-in support for some popular libraries.


#### Compass Support

Require `jekyll-assets/compass` to enable, e.g.:

``` ruby
require "jekyll-assets"
require "jekyll-assets/compass"
```

Now you can add `@import "compass"` in your SASS assets to get Compass goodies.

*Note* that if you want to use other than default Compass plugins/frameworks,
  you must require them BEFORE `jekyll-assets/compass`.


#### Bootstrap Support

Require `jekyll-assets/bootstrap` to enable, e.g.:

``` ruby
require "jekyll-assets"
require "jekyll-assets/bootstrap"
```

Now you can add `@import "bootstrap"` in your SASS assets to get Bootstrap goodies.


#### Bourbon Support

Require `jekyll-assets/bourbon` to enable, e.g.:

``` ruby
require "jekyll-assets"
require "jekyll-assets/bourbon"
```

Now you can add `@import "bourbon"` in your SASS assets to get Bourbon goodies.


#### Font Awesome

Require `jekyll-assets/font-awesome` to enable, e.g.:

``` ruby
require "jekyll-assets"
require "jekyll-assets/font-awesome"
```

Now you can add `@import "font-awesome"` in your SASS assets to get Font Awesome goodies.


#### Neat Support

Require `jekyll-assets/neat` to enable, e.g.:

``` ruby
require "jekyll-assets"
require "jekyll-assets/neat"
```

Now you can add `@import "neat"` in your SASS assets to get Neat goodies.


## Autoprefixer

To enable Autoprefixer, add `autoprefixer-rails` to your `Gemfile`:

``` ruby
gem "autoprefixer-rails"
```

You can configure it by creating an `autoprefixer.yml` file in your `source`
directory (by default your project's root):

``` yaml
browsers:
  - "last 1 version"
  - "> 1%"
  - "Explorer 10"
```


## The Directive Processor

*Note:* This section extracted from [Sprockets][sprockets] README.

Sprockets runs the *directive processor* on each CSS and JavaScript
source file. The directive processor scans for comment lines beginning
with `=` in comment blocks at the top of the file.

    //= require jquery
    //= require jquery-ui
    //= require backbone
    //= require_tree .

The first word immediately following `=` specifies the directive
name. Any words following the directive name are treated as
arguments. Arguments may be placed in single or double quotes if they
contain spaces, similar to commands in the Unix shell.

**Note**: Non-directive comment lines will be preserved in the final
  asset, but directive comments are stripped after
  processing. Sprockets will not look for directives in comment blocks
  that occur after the first line of code.


### Supported Comment Types

The directive processor understands comment blocks in three formats:

    /* Multi-line comment blocks (CSS, SCSS, JavaScript)
     *= require foo
     */

    // Single-line comment blocks (SCSS, JavaScript)
    //= require foo

    # Single-line comment blocks (CoffeeScript)
    #= require foo


### Sprockets Directives

You can use the following directives to declare dependencies in asset
source files.

For directives that take a *path* argument, you may specify either a
logical path or a relative path. Relative paths begin with `./` and
reference files relative to the location of the current file.

#### The `require` Directive

`require` *path* inserts the contents of the asset source file
specified by *path*. If the file is required multiple times, it will
appear in the bundle only once.

#### The `include` Directive

`include` *path* works like `require`, but inserts the contents of the
specified source file even if it has already been included or
required.

#### The `require_directory` Directive

`require_directory` *path* requires all source files of the same
format in the directory specified by *path*. Files are required in
alphabetical order.

#### The `require_tree` Directive

`require_tree` *path* works like `require_directory`, but operates
recursively to require all files in all subdirectories of the
directory specified by *path*.

#### The `require_self` Directive

`require_self` tells Sprockets to insert the body of the current
source file before any subsequent `require` or `include` directives.

#### The `depend_on` Directive

`depend_on` *path* declares a dependency on the given *path* without
including it in the bundle. This is useful when you need to expire an
asset's cache in response to a change in another file.

#### The `stub` Directive

`stub` *path* allows dependency to be excluded from the asset bundle.
The *path* must be a valid asset and may or may not already be part
of the bundle. Once stubbed, it is blacklisted and can't be brought
back by any other `require`.


## Configuration

You can fine-tune configuration by editing your `_config.yml`:

``` yaml
#
# Plugin: jekyll-assets
#
assets:
  #
  # Pathname of the destination of generated (bundled) assets relative
  # to the destination of the root.
  #
  dirname: assets
  #
  # Base URL of assets paths.
  #
  baseurl: /assets/
  #
  # Pathnames where to find assets relative to the root of the site.
  #
  sources:
    - _assets/javascripts
    - _assets/stylesheets
    - _assets/images
  #
  # Sets JS compressor. No compression by default.
  # Possible variants: 'yui', 'uglifier', nil
  #
  js_compressor: ~
  #
  # Sets CSS compressor. No compression by default.
  # Possible variants: 'yui', 'sass', nil
  #
  css_compressor: ~
  #
  # Sets cachebusting policy for generated assets.
  #
  # Possible variants:
  #
  #   none - disables cachebusting
  #
  #     source file:  _assets/javascripts/app.css
  #     output file:  _site/assets/javascriptis/app.css
  #     output URL:   /assets/javascripts/app.css
  #
  #   soft - leave filenames as-is, but `?cb=<md5>` suffix for URLs generated
  #          with `asset_path`, `javascript` and `stylesheet`:
  #
  #     source file:  _assets/javascripts/app.css
  #     output file:  _site/assets/javascriptis/app.css
  #     output URL:   /assets/javascripts/app.css?cb=4f41243847da693a4f356c0486114bc6
  #
  #   hard - (default) injects cachebusting checksum into processed filename:
  #
  #     source file:  _assets/javascripts/app.css
  #     output file:  _site/assets/javascriptis/app-4f41243847da693a4f356c0486114bc6.css
  #     output URL:   /assets/javascripts/app-4f41243847da693a4f356c0486114bc6.css
  #
  cachebust: hard
  #
  # Whenever or not cache compiled assets (disabled by default).
  # See `Compilation Cache` section of README for details.
  #
  cache: false
  #
  # Specifies list of MIME types that needs to have gzipped versions.
  # You can set it to `false` to disable gzipping. Only javascripts and
  # stylesheets are gzipped by default.
  #
  gzip: [ text/css, application/javascript ]
  #
  # Does not concatenates files requested by `javascript` and `stylesheet`
  # helpers. Instead outputs multiple files in order they are required.
  # Default: false
  #
  debug: false
  #
  # Configuration version. Used to force cache invalidation.
  # Default: 1
  #
  version: 1
```


## "Th-th-th-that's all folks!"

Feel free to follow me on [twitter][twitter], chat via [jabber][jabber] or
write an [e-mail][e-mail]. :D

[twitter]:  https://twitter.com/zapparov
[jabber]:   xmpp://zapparov@jabber.ru
[e-mail]:   mailto://ixti@member.fsf.org


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

Copyright (C) 2012-2013 Aleksey V Zapparov (http://ixti.net/)

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the “Software”), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
