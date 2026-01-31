import 'package:expenses_app/constants.dart';
import 'package:expenses_app/widgets/large_spacing.dart';
import 'package:expenses_app/widgets/medium_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/dependency_container.dart';
import 'package:expenses_app/l10n/app_localizations.dart';
import '../widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    final name = _nameController.text.trim();
    final password = _passwordController.text;
    try {
      final userService = DependencyContainer().userService;
      final prefs = DependencyContainer().preferencesService;

      final existing = await userService.getUser(name, password);
      if (existing != null) {
        // successful authentication: store raw hex string (oid) instead of ObjectId.toString()
        await prefs.saveUserId(existing.id ?? '');
        if (!mounted) return;
        context.go('/');
        return;
      }

      // Either user didn't exist or password didn't match. Check by name.
      final byName =
          await DependencyContainer().userRepository.findByName(name);
      if (byName != null) {
        // user exists but wrong password
        setState(() {
          _error = 'Invalid name or password';
          _loading = false;
        });
        return;
      }

      // create new user
      final created =
          await userService.createUser(name: name, password: password);
      await prefs.saveUserId(created.id ?? '');
      if (!mounted) return;
      context.go('/');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.appTitle ?? 'Login'),
      ),
      body: Padding(
        padding: kScreenPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              child: Padding(
                padding: kScreenPadding,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: loc?.labelName ?? 'User name',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? (loc?.pleaseEnterName ?? 'Please enter name')
                            : null,
                      ),
                      const MediumSpacing(),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (v) => (v == null || v.isEmpty)
                            ? ('Please enter password')
                            : null,
                      ),
                      const LargeSpacing(),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          onPressed: _loading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _submit();
                                  }
                                },
                          child: _loading
                              ? const SizedBox(
                                  width: kPadding24,
                                  height: kPadding24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
