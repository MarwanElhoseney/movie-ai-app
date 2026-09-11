import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profile_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ProfileRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      firestore.collection('users');

  // =========================
  // Get Profile
  // =========================

  @override
  Future<ProfileModel> getProfile(String userId) async {
    final doc = await _users.doc(userId).get();

    final firebaseUser = firebaseAuth.currentUser;

    if (!doc.exists) {
      return ProfileModel(
        id: userId,
        name: firebaseUser?.displayName ?? '',
        email: firebaseUser?.email ?? '',
      );
    }

    return ProfileModel.fromMap(doc.data() ?? {}, id: userId);
  }

  // =========================
  // Check Name Availability
  // =========================

  @override
  Future<bool> isNameTaken({
    required String name,
    required String currentUserId,
  }) async {
    final normalizedName = name.trim().toLowerCase();

    if (normalizedName.isEmpty) {
      return false;
    }

    final querySnapshot = await _users
        .where('nameLowercase', isEqualTo: normalizedName)
        .limit(10)
        .get();

    // Check if another user has this name
    for (final doc in querySnapshot.docs) {
      if (doc.id != currentUserId) {
        return true;
      }
    }

    return false;
  }

  // =========================
  // Update Profile
  // =========================

  @override
  Future<void> updateProfile({
    required String userId,
    required String name,
    required String email,
    required String phoneNumber,
  }) async {
    final trimmedName = name.trim();

    await _users.doc(userId).set({
      'name': trimmedName,

      // Used for case-insensitive name checking
      'nameLowercase': trimmedName.toLowerCase(),

      // Email is intentionally NOT changed
      'email': email,

      'phoneNumber': phoneNumber,

      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final user = firebaseAuth.currentUser;

    if (user != null) {
      await user.updateDisplayName(trimmedName);
    }
  }

  // =========================
  // Update Settings
  // =========================

  @override
  Future<void> updateSetting({
    required String userId,
    String? language,
    String? country,
    bool? notificationsEnabled,
  }) async {
    final Map<String, dynamic> data = {};

    if (language != null) {
      data['language'] = language;
    }

    if (country != null) {
      data['country'] = country;
    }

    if (notificationsEnabled != null) {
      data['notificationsEnabled'] = notificationsEnabled;
    }

    if (data.isEmpty) {
      return;
    }

    await _users.doc(userId).set(data, SetOptions(merge: true));
  }
}
