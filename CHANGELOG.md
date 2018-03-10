## [Unreleased] - Planned as: [3.0.9]
## [3.0.8] - 2018-3-10
### Added
- Add support for adding Clojure style `/* @alternate */`
- `:jekyll_assets_sassc` compressor.
- `:jekyll_assets_uglify` compressor.
- `:jekyll_assets_scss` compressor.

### Hooks
- Added `asset` -> `after_compression`
  This is useful for when you wish to implement things after compressing,
  but before writing, or any other kind of pre-write transformations that might
  happen within Sprockets.

### Fixed
- Made sure to only enable Uglify.js when JavaScript is available.

### Changes
- Revamped SourceMap integrations.
- Improved Utils.javascript? to return a boolean.
- Made AutoPrefixer load early, because it breaks a lot of stuff if not.
- Improved Utils.activate to return a boolean.
- Moved SourceMaps to the Plugin folder.

### API Changes
- `SprocketsExportersFileExporterPatches` -> `SprocketsWriterPatches`
- Moved `Env.old_sprockets?`, and `Env.old?` to `Utils.old_sprockets?`
- [Alpha Feature]: Moved SourceMaps to the Plugin folder.

## [3.0.7] - 2018-1-29
### Added

- Added a link to the migration guide.
- Make sure our defaults run first, so they never override plugin defaults.
- Add support for SASSC compression.  This speeds us up a bit.
- Added total time taken to do work as a final log.

#### Hooks
- Added `asset` -> `before_read`
- Added `asset` -> `before_write`
- Added `asset` -> `after_write`
- Added `asset` -> `after_read`

### Changes

- Allow `+` in Content-Types.
- Fix hook, where assets wouldn't generate.
- Fixed a bug with loopy Proxies, thanks @benben
- Refactored the way we handle `env` -> `after_write`. Now with 100% more asset.
- Moved `Utils.with_timed_logging` to `Logger.with_timed_logging`
- Refactored `Logger` to give it far less complexity.
- Encapsulate and handle errors more cleanly.
- Fixed a bug with discovering SVG images.
- Start colorizing the log.

## [3.0.5, 3.0.6] - 2017-12-05
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
- SourceMaps for SASS, JavaScript. (*sponsored-by* @cameronmcefee)
- HTML Builder Defaults
- HTML Builders
