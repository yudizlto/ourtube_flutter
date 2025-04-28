import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/mocks/models/mock_user_model.dart';

/// **MockAuthDataSource for Unit Testing**
///
/// A mock implementation of `AuthDataSource` for testing purposes
/// Uses `FakeFirebaseFirestore` to simulate Firestore interactions
class MockAuthDataSource extends Mock {
  /// Fake Firestore instance for testing
  final _fakeFirestore = FakeFirebaseFirestore();

  /// Simulates adding user data to Firestore
  Future<void> addUserDataToFireStore(MockUserModel user) async {
    await _fakeFirestore.collection("users").doc(user.userId).set(user.toMap());
    // print(_fakeFirestore.dump());
  }

  /// Simulates checking if a user exists in Firestore
  /// Returns a document snapshot if found, otherwise null
  Future<DocumentSnapshot<Map<String, dynamic>>?> checkIfUserExists(
      String email) async {
    final snapshot = await _fakeFirestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    // print("snapshot: ${snapshot.docs.first.data()}");
    return snapshot.docs.isNotEmpty ? snapshot.docs.first : null;
  }
}
