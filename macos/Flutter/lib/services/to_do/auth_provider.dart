import 'package:e_serve/services/to_do/auth_user.dart';
// we want our auth provider to provide us with the current user
// can extend for more auth provider

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
