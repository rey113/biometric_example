import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLogin extends StatefulWidget {
  const BiometricLogin({super.key});

  @override
  State<BiometricLogin> createState() => _BiometricLoginState();
}

class _BiometricLoginState extends State<BiometricLogin> {
  final LocalAuthentication auth = LocalAuthentication();

  bool isAuthenticated = false;
  bool isDeviceSupported = false;
  List<BiometricType> availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkDeviceSupport();
  }

  Future<void> _checkDeviceSupport() async {
    isDeviceSupported = await auth.isDeviceSupported();
    availableBiometrics = await auth.getAvailableBiometrics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Biometric Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'My Balance',
            ),
            const SizedBox(height: 20),
            if (isAuthenticated)
              const Text(
                '12400',
              )
            else
              const Text(
                '********',
              ),
            const SizedBox(height: 20),
            // Uncomment to display available biometric types
            Text('Available Biometrics: $availableBiometrics'),

            // Uncomment to show device support status
            Text(isDeviceSupported ? 'Biometric Supported' : 'Biometric Not Supported'),
          ],
        ),
      ),
      floatingActionButton: _authButton(),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!isAuthenticated) {
          final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;

          if (canAuthenticateWithBiometrics) {
            try {
              final bool didAuthenticate = await auth.authenticate(
                localizedReason: 'Please authenticate to show account balance',
                options: const AuthenticationOptions(
                  biometricOnly: false, // Set to true to allow only biometrics
                  useErrorDialogs: true, // Set to false to disable system error dialogs
                  stickyAuth: true, // Keeps authentication session active if the app goes to background
                ),
              );
              setState(() {
                isAuthenticated = didAuthenticate;
              });
            } catch (e) {
              print(e);
            }
          }
        } else {
          setState(() {
            isAuthenticated = false;
          });
        }
      },
      child: Icon(isAuthenticated ? Icons.lock : Icons.lock_open),
    );
  }
}
