# V Chat Firebase FCM Example

Credential-safe diagnostics application for `v_chat_firebase_fcm`. It validates Firebase initialization, notification permission, FCM registration-token retrieval, token deletion, and provider cleanup without storing project credentials in source control.

## Modes

- **Configuration-help mode:** starts without Firebase values and explains what is missing.
- **Live diagnostics mode:** initializes Firebase from `--dart-define` values and enables provider controls.

The zero-configuration mode is intentional and is covered by widget tests.

## Run without Firebase

```bash
flutter pub get
flutter run
```

Expected result: the app opens, displays **Configuration required**, and keeps notification actions disabled.

## Run with Firebase

```bash
flutter run \\
  --dart-define=FIREBASE_API_KEY=your-api-key \\
  --dart-define=FIREBASE_APP_ID=your-app-id \\
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id \\
  --dart-define=FIREBASE_PROJECT_ID=your-project-id
```

Required values:

| Define | Firebase value |
| --- | --- |
| `FIREBASE_API_KEY` | Web API key for the Firebase application |
| `FIREBASE_APP_ID` | Platform-specific Firebase App ID |
| `FIREBASE_MESSAGING_SENDER_ID` | Cloud Messaging sender ID |
| `FIREBASE_PROJECT_ID` | Firebase project ID |

Optional values:

- `FIREBASE_AUTH_DOMAIN`
- `FIREBASE_STORAGE_BUCKET`

Use the Firebase application matching the platform and bundle/application ID being run.

## Diagnostic Actions

After successful initialization, the application can:

1. request notification permission;
2. refresh and display the current registration token;
3. copy the token for backend-console testing;
4. delete the registration token and clear notifications;
5. report initialization and runtime errors without exposing credentials.

Token display is for local diagnostics only. Do not include registration tokens in screenshots, bug reports, or committed logs.

## Platform Preparation

### Android

Use a Firebase Android application matching `com.vchatsdk.v_chat_firebase_fcm_example`. The device or emulator must have working Google Play Services for FCM token retrieval.

### iOS and macOS

Use Firebase applications matching the Xcode bundle identifiers. Enable Push Notifications, configure Background Modes where required, and upload valid APNs credentials to Firebase.

### Web

Firebase initialization can be validated on web. Browser push-token retrieval may additionally require a web push certificate/VAPID key and notification permission in a secure context.

## Test and Build

```bash
flutter analyze
flutter test
flutter build apk --debug
flutter build web
```

The test suite verifies mandatory configuration detection and safe startup without credentials.

## Security

- Supply values through local commands or CI secret injection.
- Never commit service-account JSON, APNs private keys, server keys, or production tokens.
- Firebase client values are not server credentials, but they still belong to the correct application environment.
- Use separate Firebase projects or applications for development and production.

## Related Package

See the parent [`v_chat_firebase_fcm` README](../README.md) for V Chat payload requirements and SDK integration.
