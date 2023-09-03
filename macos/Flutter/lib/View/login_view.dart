// ignore_for_file: use_build_context_synchronously

import 'package:e_serve/Models/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 215, 35, 35),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/logo5.png',
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.width / 3,
            ),
            const SizedBox(
              height: 100,
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16), // Set the border radius
              ),
              child: TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '  Enter email',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Adjust padding here

                  border:
                      InputBorder.none, // Set border to none to remove the line
                  focusedBorder: InputBorder.none, // Remove the line on focus
                  enabledBorder:
                      InputBorder.none, // Remove the line when not focused
                  errorBorder:
                      InputBorder.none, // Remove the line when there's an error
                  disabledBorder:
                      InputBorder.none, // Remove the line when disabled
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16), // Set the border radius
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: '  Enter password',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Adjust padding here
                  border:
                      InputBorder.none, // Set border to none to remove the line
                  focusedBorder: InputBorder.none, // Remove the line on focus
                  enabledBorder:
                      InputBorder.none, // Remove the line when not focused
                  errorBorder:
                      InputBorder.none, // Remove the line when there's an error
                  disabledBorder:
                      InputBorder.none, // Remove the line when disabled
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  if (user?.emailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      storesRoute,
                      (route) => false,
                    );
                  }
                  //not verified
                  else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    await showErrorDialog(
                      context,
                      'User not found',
                    );
                  } else if (e.code == 'wrong-password') {
                    await showErrorDialog(
                      context,
                      'Wrong password',
                    );
                  } else {
                    await showErrorDialog(
                      context,
                      'Error: ${e.code}',
                    );
                  }
                } catch (e) {
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not registered yet? Register here!',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
            )
          ],
        ),
      ),
    );
  }
}
