import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    await _databaseManager.setData(
      collection: 'users',
      documentId: user.uid,
      data: {
        'id': user.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      },
    );

    return credential;
  }

  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> checkEmailExists({required String email}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
