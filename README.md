<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

[Quick Assists](https://flutter.dev/docs/development/tools/android-studio#assists--quick-fixes) for [GetX](https://github.com/jonataslaw/getx).

## Features

1. Wrap with Obx assist.

## Getting started

pubspec.yaml
```buildoutcfg
dev_dependencies:
  getx_assist:
    git: https://github.com/fenrir-cd/getx_assist.git
```
analysis_options.yaml
```buildoutcfg
analyzer:
  plugins:
    - getx_assist
```

## Additional information

[analyzer_plugin tutorial](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_plugin/doc/tutorial)
