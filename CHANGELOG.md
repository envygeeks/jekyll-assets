## [Unreleased]
### Changes

- Allow `+` in Content-Types.
- Encapsulate and handle errors more cleanly.
- Start colorizing the log.

### Added

- Add support for SASSC compression.  This speeds us up a bit.

## [3.0.5] - 2017-12-05
### Fixed

- Make sure we remove non-digested assets, so we can write them again.  We
  will subscribe to the always write method of handling non-digesting so that
  we don't run into any problems when working with non-digested assets.

## [3.0.4] - 2017-12-05
### Added

- `env` -> `before_write`, hook.

### Changed

- Use Regexp's for our HTML builders.
- Optimize our writes, speeding up our system slightly.  The reason this is
  slightly faster is because of the way Sprockets handles writing, if we do
  it all at once, it's much faster than doing it one at a time.

### Fixed

- Don't output a path when doing `@inline`


## [3.0.3] - 2017-11-29
### Added

- Allow lowercase DOCTYPE. #455
- Prevent network connections on XML.
- Add support for non-digest assets again (*sponsored-by* @anomaly) #458
- Show how to use WebComponents.

### Fixed

- Make sure loops aren't broken. #449
- Make sure we exclude some of our directories. #456.
- Only search for `<img>` inside of `.html`, `.md`
- Make proxies deterministic. #451
- Prevent Entity Decoding.

## [3.0.2] - 2017-11-27
### Fixed

- Added support for Favicon #448
- Enforce minimum Ruby version so people don't try to use older versions
  of Ruby even though we note the minimum version inside of the README.

## [3.0.1] - 2017-11-21
### Added

- `jekyll-assets.rb`

## [3.0.0] - 2017-11-21
### Changed

- Rewrite for Sprockets 4.x
- Rewrite Proxies so they are cleaner, and faster/cached.
- Rewrite the Hook System.

### Added

- Sprockets 4.x support.
- SourceMaps for SASS, JavaScript.
- HTML Builder Defaults
- HTML Builders
