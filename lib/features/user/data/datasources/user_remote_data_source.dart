import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

abstract class UserDataSource {
  Stream<UserModel> getUserDataStream(String userId);
  Stream<List<UserModel>> getAllUsersExceptCurrentUser(String userId);
}

class UserRemoteDataSource extends UserDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSource(this._firestore);

  /// Retrieves a stream of a single user's data from Firestore
  @override
  Stream<UserModel> getUserDataStream(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .snapshots()
        .map((doc) => UserModel.fromMap(doc.data()!));
  }

  /// Retrieves a stream of all users except the current user from Firestore
  @override
  Stream<List<UserModel>> getAllUsersExceptCurrentUser(String userId) {
    return _firestore
        .collection("users")
        .where(FieldPath.documentId, isNotEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }
}
