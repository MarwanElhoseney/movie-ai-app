import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/database/database_manager.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final DatabaseManager _databaseManager;

  AuthRemoteDataSource({
    FirebaseAuth? firebaseAuth,
    DatabaseManager? databaseManager,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _databaseManager = databaseManager ?? DatabaseManager();

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    await user.reload();

    final updatedUser = _firebaseAuth.currentUser!;

    if (!updatedUser.emailVerified) {
      await _firebaseAuth.signOut();

      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email before logging in.',
      );
    }

    return credential;
  }

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential =
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    await user.sendEmailVerification();

    return credential;
  }

  // =========================
  // Google Sign In
  // =========================

  Future<UserCredential> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize();

    final googleUser = await googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential =
    await _firebaseAuth.signInWithCredential(credential);

    final user = userCredential.user!;

    // Check if user already exists in Firestore
    final existingUser = await _databaseManager.getData(
      collection: 'users',
      documentId: user.uid,
    );

    // If this is the first Google login
    // create the user document
    if (existingUser == null) {
      await _databaseManager.setData(
        collection: 'users',
        documentId: user.uid,
        data: {
          'id': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'provider': 'google',
          'emailVerified': true,
        },
      );
    }

    return userCredential;
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> checkEmailExists({
    required String email,
  }) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}