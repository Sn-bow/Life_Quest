# Compatibility patch

Upstream: https://pub.dev/packages/phosphor_flutter/versions/1.4.0 (MIT).

Flutter 3.47 makes IconData final. The upstream wrapper subclasses it, preventing compilation. This local copy replaces the subclass instances with constant IconData values with identical code points, font family and package, and preserves the font and MIT license. No font artwork changes. The old type name is an alias. Remove this fork when an upstream compatible release has been validated.
