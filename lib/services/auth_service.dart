import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/app_enums.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_authErrorMapper(e));
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_authErrorMapper(e));
    } catch (e) {
      throw Exception('Failed to create account: ${e.toString()}');
    }
  }

  Future<void> completeUserProfile({
    required String username,
    required int age,
    required Gender gender,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      final appUser = AppUser(
        uid: user.uid,
        username: username,
        email: user.email ?? '',
        gender: gender,
        age: age,
      );

      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
    } catch (e) {
      throw Exception('Failed to complete profile: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to log out: ${e.toString()}');
    }
  }

  Future<bool> userExists(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check user: ${e.toString()}');
    }
  }

  String _authErrorMapper(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password is too weak.';

      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
