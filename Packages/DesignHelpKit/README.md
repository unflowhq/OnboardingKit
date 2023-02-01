# DesignHelpKit

A micro package to help when working with design assets in other packages.

It provides helpers that dont have any underlying knowledge of the assets they work with - you'll have to provide that.

## Fonts

`FontDisplayable` is a simple wrapper to allow modelling fonts without needing direct knowledge of the font. 
There's neat extensions included to handle registering your fonts too - without needing to use Info.plist's.

## Sample

For example of the usage of this package, see `MinimalOnboarding`.

It uses `DesignHelpKit` to make sure that its fonts are registered, and that its images can nicely come from the module without too much work.
This reduces the amount of work needed for clean callsites to just one extension to provide the `.module` as a default argument.

Fonts should be processed in your `Package.swift` in order to be compatible with `DesignHelpKit`.
