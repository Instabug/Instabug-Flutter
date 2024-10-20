# Changelog

## Unreleased

- Enables `InstabugHttpClient` to wrap an internal `http` client.
- Add support for `http` v1 ([#20](https://github.com/Instabug/Instabug-Dart-http-Adapter/pull/20)).

## [2.4.0] - 7/05/2024

### Added

- Add support for Instabug Flutter SDK v12 and v13 ([#17](https://github.com/Instabug/Instabug-Dart-http-Adapter/pull/17)).

## [2.3.0] - 3/11/2022

- Adds support for MultipartRequest.

## [2.2.1] - 2/8/2022

- Bumps [instabug_flutter](https://pub.dev/packages/instabug_flutter) to v11

## [2.2.0] - 11/4/2022

- Adds support for logging network requests using `send` method.

## [2.1.0] - 5/1/2022

- Fixes network log compilation error.
- Adds payload size for network log.

## [2.0.0] - 30/11/2021

- Upgrades to null safety.

## [1.0.0] - 29/7/2019

- Adds implementation for the instabug_http_client library which supports Instabug network logging for the dart library: http.
