import 'dart:developer';

import 'package:e_serve/Controlers/client_controllers.dart';
import 'package:e_serve/Controlers/orders_controllers.dart';
import 'package:e_serve/Controlers/stores_controllers.dart';
import 'package:e_serve/Controlers/user_controllers.dart';
import 'package:e_serve/View/login_view.dart';
import 'package:e_serve/View/stores_view.dart';
import 'package:e_serve/View/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //wait for firebase init to end end then build the widget
    WidgetsFlutterBinding.ensureInitialized();
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        //vlepw ean einai syndedemenh vash apo to state poy einai to snapshot
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                //log('Emeil verified');
                //getAllClients();
                //getAllOrders();
                getAllUsers();
                //getAllStores();
                return const StoresView();
              } else {
                log("not verified");
                log(user.emailVerified.toString());
                //log(user.toString());
                return const VerifyEmailView();
              }
            } else {
              log("not null");
              return const LoginView();
            }

          // print(user);
          // //if user exists take the value else take false
          // if (user?.emailVerified ?? false) {
          //   // verified
          //   return Text('Done');
          // } else {
          //   //not verified
          //   //Navigator.of(context).push(MaterialPageRoute(
          //   //  builder: (context) => const VerifyEmailView(),
          //   //));
          //   return const VerifyEmailView();
          // }
          // return const Text('Done');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
