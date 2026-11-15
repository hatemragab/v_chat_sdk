import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_firebase_fcm_example/main.dart';

const _missingConfig = FirebaseExampleConfig(
  apiKey: '',
  appId: '',
  messagingSenderId: '',
  projectId: '',
);

void main() {
  test('configuration requires all mandatory Firebase values', () {
    expect(_missingConfig.isConfigured, isFalse);
    expect(
      const FirebaseExampleConfig(
        apiKey: 'api-key',
        appId: 'app-id',
        messagingSenderId: 'sender-id',
        projectId: 'project-id',
      ).isConfigured,
      isTrue,
    );
  });

  testWidgets('runs safely without Firebase credentials', (tester) async {
    await tester.pumpWidget(const FcmExampleApp(config: _missingConfig));
    await tester.pumpAndSettle();

    expect(find.text('Configuration required'), findsOneWidget);
    expect(find.byKey(const Key('configuration-help')), findsOneWidget);
    final permissionButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Request permission'),
    );
    expect(permissionButton.onPressed, isNull);
  });
}
