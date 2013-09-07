### 0.7.2 (2013-09-07)

* Add `image` Liquid tag and filter.


### 0.7.1 (2013-08-17)

* Minor bugfix of AssetPath and small code refactoring.


### 0.7.0 (2013-08-11)

* Adds `debug` mode that outputs multiple scripts/styles instead of bundling
  them. See #40.


### 0.6.1 (2013-07-22)

* Fix regression with `asset_path`. See #38.


### 0.6.0 (2013-07-14)

* Remove `type` attributes from tags genereated by `javascript` and
  `stylesheet` helpers. See #37.
* Fix issue with nested assets not being regenerated when cache enabled.
  See #35.


### 0.5.4 (2103-07-07)

* Rename configuration options `compress.js` and `compress.css` into
  `js_compressor` and `css_compressor` respectively.
* Rename configureation option `cache_assets` into `cache`.
* Allow specify custom compilation cache path.
* Invalidate cache upon config changes.


### 0.5.3 (2013-05-25)

* Assets cache disable by default, in order to avoid "unpredictable" behavior.


### 0.5.2 (2013-05-25)

* Use Sprocket assets cache for compilation speed improvement. See #32.
  (Thanks @beanieboi).
* Minor fix in gemspec.


### 0.5.1 (2013-05-13)

* Re-use underlying asset file to avoid "recompilation" of fresh assets.


### 0.5.0 (2013-05-10)

* Fix mocks to pass tests on jekyll 1.x
* Update jekyll dependency `~> 1.0`


### 0.4.2 (2013-05-08)

* Require jekyll < 1.0.0. This is a the last release with support of 0.x branch
  of jekyll.


### 0.4.1 (2013-05-08)

* Drop forgotten liquid processor require.


### 0.4.0 (2013-05-08)

* Drop Liquid pre-processing. See #25.


### 0.3.8 (2013-04-29)

* Play nice with query strings and anchors in pathnames of requested assets.
  See #20.


### 0.3.7 (2013-04-29)

* Refactor AssetFile to avoid stale assets caching. See #23.


### 0.3.6 (2013-04-28)

* Ruby 2.0.0 support. See #16.


### 0.3.5 (2013-03-03)

* Add built-in neat support as `require "jekyll-assets/neat"`. See #18.
  (Thanks @awmichel)
* Automagically produce GZipped assets. See #17. (Thanks @beanieboi)


### 0.3.4 (2013-02-18)

* Fix assets regeneration (with --auto) issue. See #13.


### 0.3.3 (2013-02-16)

* Respect cachebust setting on assets output filenames. (Thanks @softcrumbs)


### 0.3.2 (2013-02-10)

* Allow choose cachebusting strategy (hard/soft/none). See #11.


### 0.3.1 (2013-02-02)

* Preprocess CSS/JS assets with Liquid processor.


### 0.3.0 (2013-01-08)

* Add complimentary filters (same names as tags).


### 0.2.3 (2013-01-07)

* Add built-in bourbon support as: `require "jekyll-assets/bourbon"`.


### 0.2.2 (2013-01-07)

* Add built-in compass support as: `require "jekyll-assets/compass"`.


### 0.2.1 (2012-12-31)

* Expose `Jekyll::Site` instance into assets as `site`.
* Improve assets comparison (when required with different logical names).


### 0.2.0 (2012-12-28)

* Remove logging.
* Fix `asset_path` helper within assets.
* Remove `bundles` configuration option.
  All require assets are auto-bundled now.


### 0.1.1 (2012-12-21)

* Add `baseurl` configuration option.


### 0.1.1 (2012-10-23)

* Small bug fixes and improvements.
* Add `{% asset <logical_path> %}` Liquid tag.


### 0.1.0 (2012-10-22)

* First public release.
