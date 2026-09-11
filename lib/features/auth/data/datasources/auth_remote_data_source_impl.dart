import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/database/database_manager.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final DatabaseManager _databaseManager;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    DatabaseManager? databaseManager,
  })
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _databaseManager = databaseManager ?? DatabaseManager();

  // =========================
  // Email / Password Login
  // =========================

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final credential =
    await _firebaseAuth.signInWithEmailAndPassword(
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

  // =========================
  // Email / Password Sign Up
  // =========================

  @override
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final trimmedName = name.trim();

    // Check if name is already used
    final nameExists = await checkNameExists(
      name: trimmedName,
    );

    if (nameExists) {
      throw FirebaseAuthException(
        code: 'name-already-in-use',
        message: 'This name is already in use.',
      );
    }

    final credential =
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    await user.updateDisplayName(trimmedName);

    await user.reload();

    await user.sendEmailVerification();

    await _databaseManager.setData(
      collection: 'users',
      documentId: user.uid,
      data: {
        'id': user.uid,

        'name': trimmedName,

        // Used for case-insensitive name checking
        'nameLowercase': trimmedName.toLowerCase(),

        'email': email.trim(),
        'phoneNumber': '',
        'country': '',
        'language': 'English',
        'notificationsEnabled': true,
        'membership': 'Member',
        'createdAt': FieldValue.serverTimestamp(),
        'provider': 'email',
        'emailVerified': false,
      },
    );

    return credential;
  }

  // =========================
  // Google Sign In
  // =========================

  @override
  Future<UserCredential> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize();

    final googleUser =
    await googleSignIn.authenticate();

    final googleAuth =
        googleUser.authentication;

    final credential =
    GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential =
    await _firebaseAuth.signInWithCredential(
      credential,
    );

    final user = userCredential.user!;

    // Check if user already exists in Firestore
    final existingUser =
    await _databaseManager.getData(
      collection: 'users',
      documentId: user.uid,
    );

    // =========================
    // First Google Login
    // =========================

    if (existingUser == null) {
      final originalName =
      (user.displayName ?? '').trim();

      String finalName = originalName;

      // If Google account has a name
      if (originalName.isNotEmpty) {
        finalName = await generateUniqueName(
          originalName,
        );
      }

      await _databaseManager.setData(
        collection: 'users',
        documentId: user.uid,
        data: {
          'id': user.uid,

          'name': finalName,

          // Used for case-insensitive name checking
          'nameLowercase': finalName.toLowerCase(),

          'email': user.email ?? '',
          'phoneNumber': '',
          'country': '',
          'language': 'English',
          'notificationsEnabled': true,
          'membership': 'Member',
          'createdAt': FieldValue.serverTimestamp(),
          'provider': 'google',
          'emailVerified': true,
        },
      );

      // Keep Firebase Auth display name
      await user.updateDisplayName(finalName);
    }

    return userCredential;
  }

  // =========================
  // Generate Unique Google Name
  // =========================

  Future<String> generateUniqueName(String name) async {
    final baseName = name.trim();

    if (baseName.isEmpty) {
      return baseName;
    }

    // First check the original name
    final originalExists = await checkNameExists(
      name: baseName,
    );

    if (!originalExists) {
      return baseName;
    }

    // If "Marwan" exists:
    // Marwan0
    // Marwan1
    // Marwan2
    // ...
    int number = 0;

    while (true) {
      final candidate = '$baseName$number';

      final exists = await checkNameExists(
        name: candidate,
      );

      if (!exists) {
        return candidate;
      }

      number++;
    }
  }

  // =========================
  // Reset Password
  // =========================

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  // =========================
  // Logout
  // =========================

  @override
  Future<void> logout() async {
    // Firebase logout
    await _firebaseAuth.signOut();

    // Google logout
    try {
      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      await googleSignIn.signOut();
    } catch (e) {
      // No active Google session
    }
  }

  // =========================
  // Check Email Exists
  // =========================

  @override
  Future<bool> checkEmailExists({
    required String email,
  }) async {
    final querySnapshot =
    await FirebaseFirestore.instance
        .collection('users')
        .where(
      'email',
      isEqualTo: email.trim(),
    )
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // =========================
  // Check Name Exists
  // =========================

  Future<bool> checkNameExists({
    required String name,
    String? currentUserId,
  }) async {
    final normalizedName =
    name.trim().toLowerCase();

    if (normalizedName.isEmpty) {
      return false;
    }

    final querySnapshot =
    await FirebaseFirestore.instance
        .collection('users')
        .where(
      'nameLowercase',
      isEqualTo: normalizedName,
    )
        .limit(10)
        .get();

    for (final doc in querySnapshot.docs) {
      // When editing the current user's name,
      // ignore his own document.
      if (currentUserId != null &&
          doc.id == currentUserId) {
        continue;
      }

      return true;
    }

    return false;
  }
}