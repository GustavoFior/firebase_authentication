import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  void setAuthConfigurations() {
    _auth.setLanguageCode("pt_br");
  }

  Future signinWithBiometric() async {
    var result;
    if (await _isBiometricAvailable()) {
      await _getListOfBiometricTypes();
      result = await _authenticateUser();
    }
    print(result);
  }

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }

    //if (!mounted) return isAvailable;

    isAvailable ? print('Biometric is available!') : print('Biometric is unavailable.');

    return isAvailable;
  }

  Future<List<BiometricType>?> _getListOfBiometricTypes() async {
    List<BiometricType>? listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    //if (!mounted) return;

    print(listOfBiometrics);
    return listOfBiometrics;
  }

  Future<bool> _authenticateUser() async {
    bool isAuthenticated = false;
    const androidAuthStrings = const AndroidAuthMessages(
      cancelButton: "CANCELAR",
      goToSettingsButton: "",
      //fingerprintHint: "", // TODO MUDAR
      //fingerprintNotRecognized: "fingerprintNotRecognized",
      //fingerprintRequiredTitle: "fingerprintRequiredTitle",
      //fingerprintSuccess: "fingerprintSuccess",
      goToSettingsDescription: "goToSettingsDescription",
      signInTitle: "Confirme sua digital",
    );

    try {
      isAuthenticated = await _localAuthentication.authenticate(
        biometricOnly: false,
        localizedReason: "Toque no sensor para acessar sua conta.",
        useErrorDialogs: true,
        stickyAuth: true,
        sensitiveTransaction: true,
        androidAuthStrings: androidAuthStrings,
      );
    } on PlatformException catch (e) {
      print("Exception -----> $e");
    }

    //if (!mounted) return;

    isAuthenticated ? print('User is authenticated!') : print('User is not authenticated.');
    return isAuthenticated;

    /* if (isAuthenticated) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TransactionScreen(),
        ),
      );
    } */
  }

  Future<bool> signupWithEmailAndPassword(String email, String password) async {
    try {
      setAuthConfigurations();

      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User? user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser!;

        assert(user.uid == currentUser.uid);

        // Envia e-mail de verificação
        await user.sendEmailVerification();

        return true;
      }
    } on FirebaseAuthException catch (e, s) {
      print("DEU ERRO signupWithEmailAndPassword - Exception: " + e.toString()); // FIFI TIRAR
      print("DEU ERRO signupWithEmailAndPassword - stacktrace: " + s.toString());
    }
    return false;
  }

  Future<bool> signinWithEmailAndPassword(String email, String password) async {
    try {
      setAuthConfigurations();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser!;

        assert(user.uid == currentUser.uid);

        return true;
      }
    } on FirebaseAuthException catch (e, s) {
      print("DEU ERRO signinWithEmailAndPassword - Exception: " + e.toString()); // FIFI TIRAR
      print("DEU ERRO signinWithEmailAndPassword - stacktrace: " + s.toString());
    }
    return false;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        setAuthConfigurations();
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);

          final User currentUser = _auth.currentUser!;
          assert(user.uid == currentUser.uid);

          print('signInWithGoogle succeeded: $user');

          return user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print("DEU ERRO signInWithGoogle - Exception: " + e.toString()); // FIFI TIRAR
      print("DEU ERRO signInWithGoogle - stacktrace: " + s.toString());
    }
    return null;
  }

  /* class FirebaseGoogleService implements IFirebaseGoogleService{
  Future<UserEntity> efetuaLogin() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    UserEntity userEntity;
    try {
      UserCredential userCredential;
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      userEntity = UserMapper.fromUser(userCredential.user);
      return userEntity;
    } catch (e) {
      print(e);
      print("Failed to sign in with Google: $e");
      return userEntity;
    }
  }
} */

  Future<void> signOutGoogle() async {
    try {
      await googleSignIn.signOut();
    } on FirebaseAuthException catch (e, s) {
      print("DEU ERRO signOutGoogle - Exception: " + e.toString()); // FIFI TIRAR
      print("DEU ERRO signOutGoogle - stacktrace: " + s.toString());
    }
  }
}
