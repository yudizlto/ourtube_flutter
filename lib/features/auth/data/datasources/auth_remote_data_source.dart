import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../user/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<void> addUserDataToFireStore(UserModel user);
  Future<DocumentSnapshot<Map<String, dynamic>>?> checkIfUserExists(
      String email);
}

class AuthRemoteDataSource implements AuthDataSource {
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource(this._firestore);

  @override

  /// Add user data to Firestore and stores it in the "users" collection
  Future<void> addUserDataToFireStore(UserModel user) async {
    await _firestore.collection("users").doc(user.userId).set(user.toMap());
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>?> checkIfUserExists(
      String email) async {
    final snapshot = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first : null;
  }
}
