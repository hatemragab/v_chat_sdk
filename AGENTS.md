# Repository Guidelines

## Project Structure & Module Organization

This Flutter/Dart pub workspace is coordinated by Melos. `core_packages/v_chat_sdk_core/` contains models, HTTP/socket services, and generated Chopper clients; `v_chat_receive_share/` handles platform sharing; `v_chat_sdk_sample/` is the runnable integration app. Message and room UI live in `v_ui_packages/`; Firebase FCM and OneSignal adapters live in `push_providers/`.

Each package owns its `pubspec.yaml`, `lib/`, README, changelog, and optional `example/` or `test/`. Keep public exports in `lib/<package_name>.dart` and implementation under `lib/src/`. Do not hand-edit `*.chopper.dart` or Flutter generated registrants.

## Build, Test, and Development Commands

- `flutter pub get` resolves the root workspace (Flutter 3.47+ and Dart 3.13+).
- `dart run melos run format` formats package `lib/`, `test/`, and `example/` trees.
- `dart run melos run analyze` analyzes every Flutter package serially.
- `dart run melos run test` runs all package test suites.
- `dart run melos run generate` regenerates core Chopper clients with `build_runner`.
- `cd core_packages/v_chat_sdk_sample && flutter run` launches the integration sample; use `flutter build apk --debug` or `flutter build web` for release-path checks.

Run commands from the repository root unless a package path is shown.

## Coding Style & Naming Conventions

Use null-safe Dart, two-space indentation, and formatter-friendly trailing commas. Name files `lower_snake_case.dart`, types `UpperCamelCase`, and members `lowerCamelCase`. Packages extend `flutter_lints`; fix findings instead of suppressing them. Preserve public APIs unless a breaking release is intentional.

## Testing Guidelines

Place unit and widget tests under each package's `test/` directory and name them `*_test.dart`. Mirror `lib/src/` where practical and cover serialization, parsing, provider behavior, and UI regressions introduced by a change. No coverage threshold is configured; report exact commands run and use `flutter test --coverage` when useful.

## Commit & Pull Request Guidelines

History uses short imperative subjects such as `fix low voice recorder for android`; Conventional Commit prefixes are not enforced. Keep commits to one package or behavior, and update its changelog/version for releases.

Pull requests should name affected packages, explain behavior and compatibility impact, link issues, and list validation. Add screenshots or recordings for UI changes. Include local analyzer/test results. Never commit credentials, generated build artifacts, or machine-specific paths; do not publish or release without explicit authorization.
