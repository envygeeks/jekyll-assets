v4.0.0

- Changed the way raw_precompile works. Before it would only work if the
  path was included inside of the sources, now it will take a path (that can be
  anywhere) and a hash argument `strip` that is a Regexp that can be used
  to clean the path pre-write... all assets still end up inside of the
  `destination` path.
