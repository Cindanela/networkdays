# networkdays

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Pure Dart library package (no native plugins). Flutter is a dev dependency only (for lints).

## Commands

```bash
flutter pub get                                    # install dependencies
dart test                                          # run all tests
dart test test/networkdays_test.dart               # run a single test file
dart analyze                                       # static analysis / linting
dart run coverage:test_with_coverage               # run tests with coverage (outputs coverage/lcov.info)
```

## Architecture

- **`lib/networkdays.dart`** — single library entry point; all public API is exported from here
- **`example/networkdays_example.dart`** — runnable usage example (required by pub.dev)
- **`test/`** — unit tests using `package:test` and `package:checks`
- **`analysis_options.yaml`** — extends `package:flutter_lints/flutter.yaml`; no custom lint rules

The package targets Dart `^3.12.0` / Flutter `>=1.17.0`.

## Code style

- Follow Effective Dart guidelines
- Dart 3 null safety, no `!` unless guaranteed non-null
- Arrow functions for simple one-liners
- 80 char line length

## Testing

- Use `package:test`
- Use `package:checks` for assertions
- Arrange-Act-Assert pattern

## Docs

- `///` dartdoc comments on all public APIs
- Include usage examples in doc comments

## Skills

@https://raw.githubusercontent.com/dart-lang/skills/main/skills/dart-add-unit-test/SKILL.md
@https://raw.githubusercontent.com/dart-lang/skills/main/skills/dart-run-static-analysis/SKILL.md
@https://raw.githubusercontent.com/dart-lang/skills/main/skills/dart-use-pattern-matching/SKILL.md
@https://raw.githubusercontent.com/dart-lang/skills/main/skills/dart-collect-coverage/SKILL.md
@https://raw.githubusercontent.com/dart-lang/skills/main/skills/dart-fix-runtime-errors/SKILL.md
@https://raw.githubusercontent.com/dart-lang/skills/main/skills/dart-migrate-to-checks-package/SKILL.md
