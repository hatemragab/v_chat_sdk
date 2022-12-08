import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

abstract class AuthRepo {
  static final isAuth = false.obs;

  static Future<User> get currentUser async {
    return FirebaseAuth.instance.currentUser!;
  }

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  static Future<User> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final x = (await auth.FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user!;
      isAuth.value = true;
      return x;
    } on auth.FirebaseAuthException catch (exception, s) {
      debugPrint('$exception$s');
      switch ((exception).code) {
        case 'invalid-email':
          throw 'Email address is malformed.';
        case 'wrong-password':
          throw 'Wrong password.';
        case 'user-not-found':
          throw 'No user corresponding to the given email address.';
        case 'user-disabled':
          throw 'This user has been disabled.';
        case 'too-many-requests':
          throw 'Too many attempts to sign in as this user.';
      }
      throw 'Unexpected firebase error, Please try again.';
    } catch (e, s) {
      debugPrint('$e$s');
      throw 'Login failed, Please try again.';
    }
  }

  static loginWithFacebook() async {
    FacebookAuth facebookAuth = FacebookAuth.instance;
    bool isLogged = await facebookAuth.accessToken != null;
    if (!isLogged) {
      LoginResult result = await facebookAuth
          .login(); // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // you are logged
        AccessToken? token = await facebookAuth.accessToken;
        return await handleFacebookLogin(
            await facebookAuth.getUserData(), token!);
      }
    } else {
      AccessToken? token = await facebookAuth.accessToken;
      return await handleFacebookLogin(
          await facebookAuth.getUserData(), token!);
    }
  }

  static handleFacebookLogin(
      Map<String, dynamic> userData, AccessToken token) async {
    auth.UserCredential authResult = await auth.FirebaseAuth.instance
        .signInWithCredential(
            auth.FacebookAuthProvider.credential(token.token));
    // User? user = await getCurrentUser(authResult.user?.uid ?? '');
    List<String> fullName = (userData['name'] as String).split(' ');
    String firstName = '';
    String lastName = '';
    if (fullName.isNotEmpty) {
      firstName = fullName.first;
      lastName = fullName.skip(1).join(' ');
    }
  }

  static Future<User> signUpWithEmailAndPassword({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final x = (await auth.FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailAddress, password: password))
          .user!;
      isAuth.value = true;
      return x;
    } on auth.FirebaseAuthException catch (error) {
      debugPrint('$error${error.stackTrace}');
      String message = 'Couldn\'t sign up';
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use, Please pick another email!';
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'Password must be more than 5 characters';
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.';
          break;
      }
      throw message;
    } catch (e, s) {
      debugPrint('FireStoreUtils.signUpWithEmailAndPassword $e $s');
      throw 'Couldn\'t sign up';
    }
  }

  static logout() async {
    isAuth.value = false;
    await auth.FirebaseAuth.instance.signOut();
  }

  static Future<dynamic> loginOrCreateUserWithPhoneNumberCredential({
    required auth.PhoneAuthCredential credential,
    required String phoneNumber,
    String? firstName = 'Anonymous',
    String? lastName = 'User',
    Uint8List? imageData,
  }) async {
    auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
    // User? user = await getCurrentUser(userCredential.user?.uid ?? '');
    // if (user != null) {
    //   return user;
    // } else {}
  }

  static loginWithApple() async {
    final appleCredential = await apple.TheAppleSignIn.performRequests([
      const apple.AppleIdRequest(
          requestedScopes: [apple.Scope.email, apple.Scope.fullName])
    ]);
    if (appleCredential.error != null) {
      return 'Couldn\'t login with apple.';
    }

    if (appleCredential.status == apple.AuthorizationStatus.authorized) {
      final auth.AuthCredential credential =
          auth.OAuthProvider('apple.com').credential(
        accessToken: String.fromCharCodes(
            appleCredential.credential?.authorizationCode ?? []),
        idToken: String.fromCharCodes(
            appleCredential.credential?.identityToken ?? []),
      );
      return await handleAppleLogin(credential, appleCredential.credential!);
    } else {
      return 'Couldn\'t login with apple.';
    }
  }

  static handleAppleLogin(
    auth.AuthCredential credential,
    apple.AppleIdCredential appleIdCredential,
  ) async {
    auth.UserCredential authResult =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
    // User? user = await getCurrentUser(authResult.user?.uid ?? '');
    // if (user != null) {
    //   return user;
    // } else {
    //   // user = User(
    //   //   email: appleIdCredential.email ?? '',
    //   //   firstName: appleIdCredential.fullName?.givenName ?? '',
    //   //   profilePictureURL: '',
    //   //   userID: authResult.user?.uid ?? '',
    //   //   lastName: appleIdCredential.fullName?.familyName ?? '',
    //   // );
    //   // String? errorMessage = await createNewUser(user);
    //   // if (errorMessage == null) {
    //   //   return user;
    //   // } else {
    //   //   return errorMessage;
    //   // }
    // }
  }

  static resetPassword(String emailAddress) async =>
      await auth.FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailAddress);
}
