import 'dart:io';

import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
// Google Sign-In
import 'package:google_sign_in/google_sign_in.dart';
// Apple Sign-In
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../map_view/map_view.dart'; // Import MapView to navigate after login
import '../register/register.dart'; // Import the Register page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = const FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool isLoading = false;
  String errorMessage = '';
  bool _obscureText = true;

  /// Called when the user taps the traditional login button.
  /// Uses username+password flow.
  void _attemptLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      try {
        // Example call to your existing REST endpoint
        String token = await login(username, password);
        // Store the token
        await storage.write(key: 'accessToken', value: token);

        // Navigate to MapView and replace LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MapView()),
        );
      } catch (e) {
        setState(() {
          errorMessage = 'Login failed: Invalid username or password';
          isLoading = false;
        });
      }
    }
  }

  /// Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final googleSignIn = GoogleSignIn(
        // Optionally specify the scopes, if you need more than basic profile info
        scopes: <String>[
          'email',
        ],
        serverClientId: '430449724069-2psk7vjqj8co2g2b5b35jvj5vpgfb385.apps.googleusercontent.com',
      );

      // Attempt to sign in silently first. If that fails, prompt user.
      //GoogleSignInAccount? account = await googleSignIn.signInSilently();
      final account = await googleSignIn.signIn(); // if still null, show Google UI

      if (account == null) {
        // User canceled the sign-in
        throw Exception('Google Sign-In canceled');
      }

      // googleAuth.idToken is what we usually send to our server
      final idToken = account.serverAuthCode;

      if (idToken == null) {
        throw Exception('No Google ID Token found');
      }

      // Now, exchange the Google ID token for your app's access token
      final token = await loginWithSocial('google', idToken, null);
      await storage.write(key: 'accessToken', value: token);

      // Navigate to your main screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MapView()),
        );
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Google Sign-In failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  /// Apple Sign-In
  Future<void> _signInWithApple() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Check if Apple SignIn is available on the current platform
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        throw Exception('Sign in with Apple is not available on this device');
      }

      // Perform the Apple sign-in request
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // This is the Apple ID token you send to your server
      final friendlyName = credential.givenName;
      final appleIdToken = credential.identityToken;
      if (appleIdToken == null) {
        throw Exception('No Apple ID Token found');
      }

      // Exchange Apple ID token for your app's access token
      final token = await loginWithSocial('apple', appleIdToken, friendlyName);
      await storage.write(key: 'accessToken', value: token);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MapView()),
        );
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Apple Sign-In failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please log in to continue',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // USERNAME
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        username = value;
                      },
                    ),
                    const SizedBox(height: 16),

                    // PASSWORD
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: _attemptLogin,
                      child: const Text('Login'),
                    ),

                    // ERROR MESSAGE
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    // NAVIGATE TO REGISTER
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      child:
                      const Text("Don't have an account? Register here."),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MapView(),
                          ),
                        );
                      },
                      child: const Text(
                          "Don't want to sign up? Continue as guest"),
                    ),
                    const SizedBox(height: 24),

                    // SIGN IN WITH GOOGLE
                    SignInButton(
                      Buttons.Google,
                      onPressed: _signInWithGoogle
                    ),

                    // SIGN IN WITH APPLE
                    // (Available on iOS 13+ and macOS 10.15+)
                    const SizedBox(height: 8),
                    if (Platform.isIOS)
                      SignInButton(
                          Buttons.Apple,
                          onPressed: _signInWithApple
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
