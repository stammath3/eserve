import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

// this class and all sub-classes need to be immutable (they can not have any field that changes)
@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  //factory constractor that creates authuser from a firebase user
  //does not expose all the firebase user and all of it's properties to our UI
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
