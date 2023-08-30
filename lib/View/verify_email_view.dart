import 'package:e_serve/Models/routes.dart';
import 'package:e_serve/View/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

enum MenuAction {
  logout,
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 215, 35, 35),
        title: const Text('Verify email'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  //log(shouldLogout.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, // Define this value in your enum
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(16), // Set the border radius
            // ),
            child: Padding(
              padding: EdgeInsets.all(16), // Adjust
              child: const Text(
                " We've sent you an email verification. Please open it to verify your account. \n\n If you haven't received a verification email yet, press the button bellow.",
              ),
            ),
          ),
          //const Text(
          //  "If you haven't received a verification email yet, press the button bellow."),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text(
                'Re-send email verification',
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
            onPressed: (() async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            }),
            child: const Text(
              'Restart',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
