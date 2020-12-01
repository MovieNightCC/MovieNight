import 'package:firebase_auth/firebase_auth.dart';
import 'swiper.dart';
import 'profile.dart';
import '../main.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  /// this tracks the user signing in or out globally
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    // set movie images and moviedata to empty array to avoid overfetching
    print(movieDataTest);
    // movieDataTest = [];
    // movieImagesTest = [];
    userName = "";
    pair = "";
    name = "";
    email = "";
    userdata = null;
  }



  // Sign in to with firebase authenticator
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign up user with email and password
  // adding user to database happens in signup.dart
  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
