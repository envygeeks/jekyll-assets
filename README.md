# Jekyll::AssetsPlugin

[![Build Status](https://secure.travis-ci.org/ixti/jekyll-assets.png)](http://travis-ci.org/ixti/jekyll-assets)
[![Dependency Status](https://gemnasium.com/ixti/jekyll-assets.png)](https://gemnasium.com/ixti/jekyll-assets)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/ixti/jekyll-assets)

Jekyll plugin, that adds Rails-alike assets pipeline:

- Concatenates and minify or compress JavaScript and CSS assets. You can choose
  whenever or not you want to have compression as well.
- Allows you to write these assets in other languages such as CoffeeScript, Sass
  and ERB.
- Automaticaly adds _cache bust_ suffix for the output assets.


## Installation

Add this line to your application's Gemfile:

    gem 'jekyll-assets'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-assets

Then just require `jekyll-assets` within your plugins, e.g.:

    $ echo 'require "jekyll-assets"' > _plugins/ext.rb


## Usage

Put your assets under following paths:

- `_assets/javascripts`
- `_assets/stylesheets`
- `_assets/images`

Name your "main" asset files `app.js` and `app.css` and use liquid tags:

- `{% javascript app %}` to process and output `<script>` tag for `app.js`
- `{% stylesheet app %}` to process and output `<link>` tag for `app.css`
- `{% asset_path logo.jpg %}` to process and output URL for `logo.jpg`


## Configuration

You can fine-tune configuration by editing your `_config.yml`:

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
      # Sets compressors for the specific types of file: `js`, or `css`.
      # No compression by default.
      #
      # Possible variants:
      #
      #     css  => 'yui', 'sass', nil
      #     js   => 'yui', 'uglifier', nil
      #
      compress:
        js:   ~
        css:  ~


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

Copyright (C) 2012 Aleksey V Zapparov (http://ixti.net/)

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
