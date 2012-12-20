# Jekyll::AssetsPlugin

[![Build Status](https://secure.travis-ci.org/ixti/jekyll-assets.png)](http://travis-ci.org/ixti/jekyll-assets)
[![Dependency Status](https://gemnasium.com/ixti/jekyll-assets.png)](https://gemnasium.com/ixti/jekyll-assets)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/ixti/jekyll-assets)

Jekyll plugin, that adds Rails-alike assets pipelines.


## Installation

Add this line to your application's Gemfile:

    gem 'jekyll-assets'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-assets


## Usage

Add this line to your sites `_plugins/ext.rb`:

    require 'jekyll-assets'

Put your assets under following paths:

- `_assets/javascripts`
- `_assets/stylesheets`
- `_assets/images`

Name your "main" asset files `app.js` and `app.css` and use liquid tags:

- `{% javascript app %}` to output `<script>` tag for `app.js`
- `{% stylesheet app %}` to output `<link>` tag for `app.css`
- `{% asset_path logo.jpg %}` to output URL for `logo.jpg`

In order to use these tags, assets must be "bundled". By default only `app.js`,
`app.css`, and all files with extensions `.jpg`, `.png` or `.gif` are bundled.
You can change this by tuning up you `_config.yml` (see below).


## Configuration

You can fine-tune configuration by editing your `_config.yml`:

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
      # Array of filenames or filename patterns that needs to be generated for
      # the generated site. You can use `*` and `**` wildcards in patterns:
      #
      #     'foobar.jpg'  will match 'foobar.jpg' only
      #     '*.jpg'       will match 'foo.jpg', but not 'foo/bar.jpg'
      #     '**.jpg'      will match 'foo.jpg', 'foo/bar.jpg', etc.
      #
      bundles:
        - 'app.css'
        - 'app.js'
        - '**.jpg'
        - '**.png'
        - '**.gif'
      #
      # Sets compressors for the specific types of file: `js`, or `css`.
      # No compression by default.
      #
      # Possible variants:
      #
      #     css  => 'yui', 'sass', nil
      #     js   => 'yui', 'unglifier', nil
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
