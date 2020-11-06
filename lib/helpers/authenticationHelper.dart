import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void setAuthConfigurations() {
    _auth.setLanguageCode("pt_br");
  }

  Future<bool> signupWithEmailAndPassword(String email, String password) async {
    try {
      setAuthConfigurations();

      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;

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
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;

        assert(user.uid == currentUser.uid);

        return true;
      }
    } on FirebaseAuthException catch (e, s) {
      print("DEU ERRO signinWithEmailAndPassword - Exception: " + e.toString()); // FIFI TIRAR
      print("DEU ERRO signinWithEmailAndPassword - stacktrace: " + s.toString());
    }
    return false;
  }

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      setAuthConfigurations();
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        print('signInWithGoogle succeeded: $user');

        return user;
      }
    } on FirebaseAuthException catch (e, s) {
      print("DEU ERRO signInWithGoogle - Exception: " + e.toString()); // FIFI TIRAR
      print("DEU ERRO signInWithGoogle - stacktrace: " + s.toString());
    }
    return null;
  }

  Future<void> signOutGoogle() async {
    try {
      await googleSignIn.signOut();
    } on FirebaseAuthException catch (e, s) {
      print("DEU ERRO signOutGoogle - Exception: " + e.toString()); // FIFI TIRAR
      print("DEU ERRO signOutGoogle - stacktrace: " + s.toString());
    }
  }
}
