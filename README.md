[![Build Status](https://travis-ci.org/jekyll-assets/jekyll-assets.png?branch=master)](https://travis-ci.org/jekyll-assets/jekyll-assets) [![Coverage Status](https://coveralls.io/repos/jekyll-assets/jekyll-assets/badge.png?branch=master)](https://coveralls.io/r/jekyll-assets/jekyll-assets) [![Code Climate](https://codeclimate.com/github/jekyll-assets/jekyll-assets/badges/gpa.svg)](https://codeclimate.com/github/jekyll-assets/jekyll-assets) [![Dependency Status](https://gemnasium.com/jekyll-assets/jekyll-assets.svg)](https://gemnasium.com/jekyll-assets/jekyll-assets)

# Jekyll 3 Assets

Jekyll 3 assets is an asset pipeline using Sprockets 3 for Jekyll 3.

## Configuration

```yaml
assets:
  prefix: "/assets"
  assets:
    - "*.png"
    - "bundle.css"
  digest: true
  sources:
    - "_assets/folder"
```

### Do I need to provide `assets`?

No, you don't.  That is there to make your life easier when it comes to
missing assets in a cached chain.  Take for example bundle.css, if you use
that file in another asset or with a tag it will get compiled because we
detect that the best we can, but if you change that file and it uses
a PNG image and you delete that PNG image it will not get readded because
it's cached and not compiled so our methods never get called so you'll
need to add it to the asset list so it's always compiled for you.

## When I try to use ERB I get an error

Because we disable ERB processing in the hopes that this can one day be
used on Github Pages to help you with caching, so we remove access to ERB
which will give you powerful syntax with Ruby to do what you like.

## Tags

* stylesheet, css, style
* javascript, js
* image, img
* asset_path

### Proxy/Arguments

Any arguments that are not being proxied to Sprockets will be set on the tag
that we give back to you (if we give back a tag...) so if you pass `accept:
content_type` we will search for the content type through Sprockets but if you
send `a:b` then `a="b"` will be on the tag.  You can also escape colons to
prevent mistakes: `{% css asset hello:world\:how\:are\:you }` will end up
as `<link type="text/css" rel="stylesheet" href="" hello="world:how:are:you">`
