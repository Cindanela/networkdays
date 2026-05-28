# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                                    # install dependencies
flutter test                                       # run all tests
flutter test test/networkdays_test.dart            # run a single test file
dart analyze                                       # static analysis / linting
```

## Architecture

Pure Dart library package (no native plugins). Flutter is a dev dependency only (for `flutter_test` and lints).

- **`lib/networkdays.dart`** — single library entry point; all public API is exported from here
- **`test/`** — unit tests using `flutter_test`
- **`analysis_options.yaml`** — extends `package:flutter_lints/flutter.yaml`; no custom lint rules

There is no example app. The package targets Dart `^3.12.0` / Flutter `>=1.17.0`.
