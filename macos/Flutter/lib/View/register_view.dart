// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Controlers/user_controllers.dart';
import '../Models/routes.dart';
import '../Models/show_error_dialog.dart';
import '../Models/user_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _name;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 215, 35, 35),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Set the border radius
            ),
            child: TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '  Enter email',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Adju
                  border:
                      InputBorder.none, // Set border to none to remove the line
                  focusedBorder: InputBorder.none, // Remove the line on focus
                  enabledBorder:
                      InputBorder.none, // Remove the line when not focused
                  errorBorder:
                      InputBorder.none, // Remove the line when there's an error
                  disabledBorder:
                      InputBorder.none, // Remove the line when disabled),
                )),
          ),
          Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16), // Set the border radius
              ),
              child: TextField(
                controller: _name,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: '  Enter name',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Adju
                  border:
                      InputBorder.none, // Set border to none to remove the line
                  focusedBorder: InputBorder.none, // Remove the line on focus
                  enabledBorder:
                      InputBorder.none, // Remove the line when not focused
                  errorBorder:
                      InputBorder.none, // Remove the line when there's an error
                  disabledBorder:
                      InputBorder.none, // Remove the line when disabled),
                ),
              )),
          Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16), // Set the border radius
              ),
              child: TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: '  Enter password',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Adju
                  border:
                      InputBorder.none, // Set border to none to remove the line
                  focusedBorder: InputBorder.none, // Remove the line on focus
                  enabledBorder:
                      InputBorder.none, // Remove the line when not focused
                  errorBorder:
                      InputBorder.none, // Remove the line when there's an error
                  disabledBorder:
                      InputBorder.none, // Remove the line when disabled)),
                ),
              )),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              final name = _name.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                UserMap newUser = await createUser(user!, name);
                log('New user : $newUser');
                await user.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await showErrorDialog(
                    context,
                    'Week password',
                  );
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(
                    context,
                    'Email already in use',
                  );
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(
                    context,
                    'Invalid email',
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
              'Register',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text(
              'Already registerd? Login here!',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
