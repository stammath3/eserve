import 'dart:developer';

import 'package:e_serve/Controlers/user_controllers.dart';
import 'package:e_serve/Models/show_error_dialog.dart';
import 'package:e_serve/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/routes.dart';

Future<dynamic> loginToDB(email, password, context) async {
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
    return user;
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
}

Future<dynamic> registerToDB(email, password, name, context) async {
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
}
