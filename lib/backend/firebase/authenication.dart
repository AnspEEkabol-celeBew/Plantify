import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUp(String email, String password) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "Success";
    } on FirebaseAuthException catch (e) {
      return _handleFBAuthError(e);
    }
  }

  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return _handleFBAuthError(e);
    }
  }

  String _handleFBAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "Email already exists.";
      case 'invalid-email':
        return "Invalid email format.";
      case 'weak-password':
        return "Password is too weak.";
      case 'user-not-found':
        return "User not found.";
      case 'wrong-password':
        return "Wrong password.";
      case 'too-many-requests':
        return "Too many attempts. Try again later.";
      case 'channel-error':
        return "Fill all the inputs.";
      case 'wrong-password-confirmation':
        return "Password Confirmation not match.";
      case 'invalid-credential':
        return "Wrong email and password.";
      default:
        return "Something went wrong. => ${e.code} :: $e";
    }
  }
}
