import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FcmExampleApp());
}

@immutable
class FirebaseExampleConfig {
  const FirebaseExampleConfig({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain = '',
    this.storageBucket = '',
  });

  static const fromEnvironment = FirebaseExampleConfig(
    apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
  );

  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String authDomain;
  final String storageBucket;

  bool get isConfigured =>
      apiKey.isNotEmpty &&
      appId.isNotEmpty &&
      messagingSenderId.isNotEmpty &&
      projectId.isNotEmpty;

  FirebaseOptions get options => FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain: authDomain.isEmpty ? null : authDomain,
    storageBucket: storageBucket.isEmpty ? null : storageBucket,
  );
}

class FcmExampleApp extends StatelessWidget {
  const FcmExampleApp({
    super.key,
    this.config = FirebaseExampleConfig.fromEnvironment,
  });

  final FirebaseExampleConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'V Chat FCM diagnostics',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: FcmDiagnosticsPage(config: config),
    );
  }
}

class FcmDiagnosticsPage extends StatefulWidget {
  const FcmDiagnosticsPage({required this.config, super.key});

  final FirebaseExampleConfig config;

  @override
  State<FcmDiagnosticsPage> createState() => _FcmDiagnosticsPageState();
}

class _FcmDiagnosticsPageState extends State<FcmDiagnosticsPage> {
  VChatFcmProver? _provider;
  String _status = 'Checking Firebase configuration…';
  String? _token;
  String? _error;
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!widget.config.isConfigured) {
      setState(() {
        _busy = false;
        _status = 'Configuration required';
      });
      return;
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: widget.config.options);
      }
      final provider = VChatFcmProver();
      final initialized = await provider.init();
      if (!mounted) {
        provider.close();
        return;
      }
      _provider = provider;
      _token = initialized ? await provider.getToken() : null;
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = initialized
            ? 'Provider initialized'
            : 'Initialization failed';
        if (!initialized) {
          _error = 'Check the Firebase project and platform configuration.';
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _status = 'Initialization failed';
        _error = error.toString();
      });
    }
  }

  Future<void> _runAction(Future<void> Function(VChatFcmProver) action) async {
    final provider = _provider;
    if (provider == null || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action(provider);
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _requestPermission() => _runAction((provider) async {
    await provider.askForPermissions();
    final token = await provider.getToken();
    if (!mounted) return;
    setState(() {
      _token = token;
      _status = token == null
          ? 'Permission handled; token unavailable'
          : 'Ready';
    });
  });

  Future<void> _refreshToken() => _runAction((provider) async {
    final token = await provider.getToken();
    if (!mounted) return;
    setState(() {
      _token = token;
      _status = token == null ? 'Token unavailable' : 'Token refreshed';
    });
  });

  Future<void> _deleteToken() => _runAction((provider) async {
    await provider.deleteToken();
    if (!mounted) return;
    setState(() {
      _token = null;
      _status = 'Token deleted';
    });
  });

  Future<void> _copyToken() async {
    final token = _token;
    if (token == null) return;
    await Clipboard.setData(ClipboardData(text: token));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Token copied')));
  }

  @override
  void dispose() {
    _provider?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configured = widget.config.isConfigured;
    return Scaffold(
      appBar: AppBar(title: const Text('V Chat Firebase FCM')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Provider diagnostics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'This app validates Firebase initialization, notification permission, '
              'and registration-token lifecycle without storing credentials.',
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _status,
                      key: const Key('status'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (_busy) ...[
                      const SizedBox(height: 16),
                      const LinearProgressIndicator(),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (!configured) ...[
              const SizedBox(height: 16),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Launch with FIREBASE_API_KEY, FIREBASE_APP_ID, '
                    'FIREBASE_MESSAGING_SENDER_ID, and FIREBASE_PROJECT_ID '
                    'as --dart-define values. See README.md for the full command.',
                    key: Key('configuration-help'),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _provider == null || _busy ? null : _requestPermission,
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Request permission'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _provider == null || _busy ? null : _refreshToken,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh token'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _provider == null || _busy ? null : _deleteToken,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete token'),
            ),
            if (_token != null) ...[
              const SizedBox(height: 24),
              Text(
                'Registration token',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SelectableText(_token!, key: const Key('registration-token')),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _copyToken,
                icon: const Icon(Icons.copy),
                label: const Text('Copy token'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
