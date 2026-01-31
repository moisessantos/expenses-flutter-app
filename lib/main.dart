import 'package:expenses_app/constants.dart';
import 'package:expenses_app/widgets/large_spacing.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'di/dependency_container.dart';
import 'routing/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initError;

  // Initialize dependencies
  try {
    await DependencyContainer().initialize();
    debugPrint('App initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('Error initializing app: $e');
    debugPrint('Stack trace: $stackTrace');
    initError = e.toString();
  }

  runApp(MyApp(initializationError: initError));
}

class MyApp extends StatefulWidget {
  final String? initializationError;

  const MyApp({super.key, this.initializationError});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App returned from background, ensure database connection
      debugPrint('App resumed, checking database connection...');
      DependencyContainer().ensureConnection().catchError((error) {
        debugPrint('Failed to reconnect to database: $error');
      });
    } else if (state == AppLifecycleState.paused) {
      debugPrint('App paused');
    }
  }

  @override
  Widget build(BuildContext context) {
    // If initialization failed, show error screen
    if (widget.initializationError != null) {
      return MaterialApp(
        home: InitializationErrorScreen(error: widget.initializationError!),
      );
    }

    return ValueListenableBuilder<Locale?>(
      valueListenable: DependencyContainer().localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp.router(
          locale: locale,
          onGenerateTitle: (context) =>
              AppLocalizations.of(context)?.appTitle ?? 'Budget App',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}

class InitializationErrorScreen extends StatelessWidget {
  final String error;

  const InitializationErrorScreen({super.key, required this.error});

  String _getUserFriendlyMessage(String error) {
    if (error.contains('dns.google.com') ||
        error.contains('host lookup') ||
        error.contains('no address associated')) {
      return 'Cannot connect to the database. Please check:\n\n'
          '• Your internet connection is active\n'
          '• You have mobile data or WiFi enabled\n'
          '• Network restrictions are not blocking the app\n\n'
          'Try turning WiFi off/on or switching networks.';
    }
    if (error.contains('timeout')) {
      return 'Connection timeout. The server is taking too long to respond.\n\n'
          'Please check your internet connection and try again.';
    }
    return 'The app failed to initialize. Please check your connection and try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red.shade700,
              ),
              const SizedBox(height: kPadding24),
              Text(
                'Initialization Error',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
              ),
              const LargeSpacing(),
              Text(
                _getUserFriendlyMessage(error),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: kMediumFontSize,
                  color: Colors.red.shade800,
                ),
              ),
              const SizedBox(height: kPadding24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    error,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: Colors.red.shade900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kPadding24),
              ElevatedButton.icon(
                onPressed: () {
                  // Restart the app
                  // Note: This requires app restart from outside
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Restart App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
