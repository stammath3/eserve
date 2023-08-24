import 'package:e_serve/Models/routes.dart';
import 'package:e_serve/View/home_page_view.dart';
import 'package:e_serve/View/login_view.dart';
import 'package:e_serve/View/register_view.dart';
import 'package:e_serve/View/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'View/store_details_screen.dart';
import 'View/stores_view.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        storesRoute: (context) => const StoresView(),
        //verifyEmailRoute: (context) => const VerifyEmailView(),
        homePageRoute: (context) => const HomePage(),
        //storeDetails: (context) => StoreDetailScreen(),
      },
    ),
  );
}
