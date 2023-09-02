import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppingmallflutter/main.dart';

typedef OAuthSignIn = void Function();

class ScaffoldSnackbar {
  // ignore: public_member_api_docs
  ScaffoldSnackbar(this._context);

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  final BuildContext _context;

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

enum AuthMode { login, register, phone }

extension on AuthMode {
  String get label => this == AuthMode.login
      ? 'Sign in'
      : this == AuthMode.phone
      ? 'Sign in'
      : 'Register';
}

class LoginMemberPage extends StatefulWidget {
  const LoginMemberPage({super.key, required this.title});

  final String title;

  @override
  State<LoginMemberPage> createState() => _LoginMemberPageState();
}

class _LoginMemberPageState extends State<LoginMemberPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  late Map<Buttons, OAuthSignIn> authButtons;

  String error = '';
  bool isLoading = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthMode mode = AuthMode.login;

  @override
  void initState() {
    super.initState();
    print("LoginMemberPage initState in");
    //signInWithGoogle();

    if (!kIsWeb && Platform.isMacOS) {
      authButtons = {
        Buttons.Apple: () => _handleAuthException(
          _signInWithApple,
        ),
      };
    } else {
      authButtons = {
        Buttons.Google: () => _handleAuthException(
          _signInWithGoogle,
        ),
      };
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("LoginMemberPage didChangeDependencies in");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child : Column(
                    children:[
                      Visibility(
                        visible: error.isNotEmpty,
                        child: MaterialBanner(
                          backgroundColor:
                          Theme.of(context).colorScheme.error,
                          content: SelectableText(error),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  error = '';
                                });
                              },
                              child: const Text(
                                'dismiss',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                          contentTextStyle:
                          const TextStyle(color: Colors.white),
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: (value) =>
                        value != null && value.isNotEmpty
                            ? null
                            : 'Required',
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value != null && value.isNotEmpty
                            ? null
                            : 'Required',
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _handleAuthException(
                                  _emailAndPassword,
                                ),
                              child: isLoading
                              ? const CircularProgressIndicator.adaptive()
                              : Text(mode.label),
                        ),
                      ),
                      TextButton(
                        onPressed: _resetPassword,
                        child: const Text('Forgot password?'),
                      ),
                      ...authButtons.keys
                          .map(
                            (button) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: isLoading
                                  ? Container(
                                      color: Colors.grey[200],
                                      height: 50,
                                      width: double.infinity,
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: SignInButton(
                                        button,
                                        onPressed: authButtons[button]!,
                                      ),
                                    ),
                              ),
                            ),
                          ).toList(),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: mode == AuthMode.login
                                  ? "Don't have an account? "
                                  : 'You have an account? ',
                            ),
                            TextSpan(
                              text: mode == AuthMode.login
                                  ? 'Register now'
                                  : 'Click to login',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    mode = mode == AuthMode.login
                                        ? AuthMode.register
                                        : AuthMode.login;
                                  });
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              )
            )
          ),
        ),
      ),
    );
  }

  Future _resetPassword() async {
    String? email;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Send'),
            ),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your email'),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  email = value;
                },
              ),
            ],
          ),
        );
      },
    );

    if (email != null) {
      try {
        await auth.sendPasswordResetEmail(email: email!);
        ScaffoldSnackbar.of(context).show('Password reset email is sent');
      } catch (e) {
        ScaffoldSnackbar.of(context).show('Error resetting');
      }
    }
  }

  Future<void> _handleAuthException(Future<void> Function() authFunction,) async {
    print("_LoginMemberPageState _handleAuthException in");
    setIsLoading();
    try {
      await authFunction();
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = '${e.message}';
      });
    } catch (e) {
      setState(() {
        error = '$e';
      });
    }
    print("_LoginMemberPageState _handleAuthException out");

    setIsLoading();
    //로그인 성공하면 위젯을 종료한다.
    if(error.isEmpty) {
     Navigator.of(context).pop(true);
    }
  }

  Future<void> _emailAndPassword() async {
    print("_LoginMemberPageState _emailAndPassword in");

    if (formKey.currentState?.validate() ?? false) {
      print("_LoginMemberPageState _emailAndPassword AuthMode.login = ${mode}");
      if (mode == AuthMode.login) {
        await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else if (mode == AuthMode.register) {
        await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        await _phoneAuth();
      }
    }

    print("_LoginMemberPageState _emailAndPassword in");
  }

  Future<void> _phoneAuth() async {
    if (mode != AuthMode.phone) {
      setState(() {
        mode = AuthMode.phone;
      });
    } else {
      if (kIsWeb) {
        final confirmationResult =
        await auth.signInWithPhoneNumber(phoneController.text);
        final smsCode = await getSmsCodeFromUser(context);

        if (smsCode != null) {
          await confirmationResult.confirm(smsCode);
        }
      } else {
        await auth.verifyPhoneNumber(
          phoneNumber: phoneController.text,
          verificationCompleted: (_) {},
          verificationFailed: (e) {
            setState(() {
              error = '${e.message}';
            });
          },
          codeSent: (String verificationId, int? resendToken) async {
            final smsCode = await getSmsCodeFromUser(context);

            if (smsCode != null) {
              // Create a PhoneAuthCredential with the code
              final credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: smsCode,
              );

              try {
                // Sign the user in (or link) with the credential
                await auth.signInWithCredential(credential);
              } on FirebaseAuthException catch (e) {
                setState(() {
                  error = e.message ?? '';
                });
              }
            }
          },
          codeAutoRetrievalTimeout: (e) {
            setState(() {
              error = e;
            });
          },
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
    }
  }

  Future<void> _signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');

    if (kIsWeb) {
      // Once signed in, return the UserCredential
      await auth.signInWithPopup(appleProvider);
    } else {
      await auth.signInWithProvider(appleProvider);
    }
  }

  Future<void> _signInWithYahoo() async {
    final yahooProvider = YahooAuthProvider();

    if (kIsWeb) {
      // Once signed in, return the UserCredential
      await auth.signInWithPopup(yahooProvider);
    } else {
      await auth.signInWithProvider(yahooProvider);
    }
  }

  Future<void> _signInWithGitHub() async {
    final githubProvider = GithubAuthProvider();

    if (kIsWeb) {
      await auth.signInWithPopup(githubProvider);
    } else {
      await auth.signInWithProvider(githubProvider);
    }
  }

  Future<void> _signInWithMicrosoft() async {
    final microsoftProvider = MicrosoftAuthProvider();

    if (kIsWeb) {
      await auth.signInWithPopup(microsoftProvider);
    } else {
      await auth.signInWithProvider(microsoftProvider);
    }
  }
}

Future<String?> getSmsCodeFromUser(BuildContext context) async {
  String? smsCode;

  // Update the UI - wait for the user to enter the SMS code
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('SMS code:'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Sign in'),
          ),
          OutlinedButton(
            onPressed: () {
              smsCode = null;
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
        content: Container(
          padding: const EdgeInsets.all(20),
          child: TextField(
            onChanged: (value) {
              smsCode = value;
            },
            textAlign: TextAlign.center,
            autofocus: true,
          ),
        ),
      );
    },
  );

  return smsCode;
}
