import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/app_enums.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Future<bool> signIn(String email, String password) async {
  //   try {
  //     final userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user != null;
  //   } on FirebaseAuthException catch (e) {
  //     throw _authErrorMapper(e);
  //   }
  // }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  // Future<User?> signUpWithEmail({
  //   required String email,
  //   required String password,
  // }) async {
  //   if (!_isValidEmail(email)) {
  //     throw Exception("Invalid email format");
  //   }
  //
  //   if (!_isValidPassword(password)) {
  //     throw Exception("Invalid password");
  //   }
  //
  //   try {
  //     final userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     throw _authErrorMapper(e);
  //   }
  // }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to create account: ${e.toString()}');
    }
  }

  // Future<void> completeSignUp({
  //   required String uid,
  //   required String username,
  //   required int age,
  //   required String gender,
  // }) async {
  //   final user = _auth.currentUser;
  //
  //   if (user == null) throw Exception("User is not authenticated");
  //
  //   // Check if the username is available before saving
  //   final isAvailable = await isUsernameAvailable(username);
  //   if (!isAvailable) {
  //     throw Exception("Username is already taken");
  //   }
  //
  //   AppUser appUser = AppUser(
  //     uid: uid,
  //     username: username.isNotEmpty ? username : 'Guest',
  //     email: user.email ?? '',
  //     gender: gender,
  //     age: age,
  //   );
  //
  //   await _firestore.collection('users').doc(uid).set(appUser.toMap());
  // }

  // Complete user profile setup
  Future<void> completeUserProfile(
      String uid, String username, int age, Gender gender) async {
    try {
      // Create user document in Firestore
      final user = AppUser(
        uid: uid,
        username: username,
        email: _auth.currentUser!.email!,
        gender: gender,
        age: age,
      );

      await _firestore.collection('users').doc(uid).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to complete profile: ${e.toString()}');
    }
  }

  // Future<bool> isUsernameAvailable(String username) async {
  //   final query = await _firestore
  //       .collection('users')
  //       .where('username', isEqualTo: username)
  //       .limit(1)
  //       .get();
  //
  //   return query.docs.isEmpty;
  // }

  // // Email validation regex
  // bool _isValidEmail(String email) {
  //   final emailRegEx = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  //   return emailRegEx.hasMatch(email);
  // }
  //
  // // Password validation (e.g., minimum length of 6 characters)
  // bool _isValidPassword(String password) {
  //   return password.length >= 6;
  // }

  // Future<void> signOut() async {
  //   await _auth.signOut();
  // }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to log out: ${e.toString()}');
    }
  }

  // Future<AppUser?> getUserData(String uid) async {
  //   try {
  //     final doc = await _firestore.collection('users').doc(uid).get();
  //     if (doc.exists) return AppUser.fromFirestore(doc);
  //     return null;
  //   } catch (e) {
  //     print("Error fetching user data: $e");
  //     return null;
  //   }
  // }

  // Get user data from Firestore
  Future<AppUser?> getUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
      await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  // String _authErrorMapper(FirebaseAuthException e) {
  //   switch (e.code) {
  //     case 'invalid-email':
  //       return 'Invalid email format';
  //     case 'user-not-found':
  //       return 'No user found with this email';
  //     case 'wrong-password':
  //       return 'Incorrect password';
  //     case 'email-already-in-use':
  //       return 'This email is already registered';
  //     case 'weak-password':
  //       return 'Password is too weak (min 6 characters)';
  //     default:
  //       return 'Authentication failed: ${e.message}';
  //   }
  // }

  // Stream of user data from Firestore
  Stream<AppUser?> userDataStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
  }
}