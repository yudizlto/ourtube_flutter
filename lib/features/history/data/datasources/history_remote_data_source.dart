import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/history_model.dart';

abstract class HistoryDataSource {
  Future<HistoryModel?> findExistingHistoryDoc(String userId, String videoId);
  Future<void> addHistoryToFirestore(HistoryModel history);
  Future<void> updateHistoryData(
      String historyId, Map<String, dynamic> fieldsToUpdate);
  Future<List<HistoryModel>> getMyVideoHistory(
      String userId, bool sortByLatest);
  Future<void> deleteHistoryFromFirestore(String historyId);
}

class HistoryRemoteDataSource implements HistoryDataSource {
  final FirebaseFirestore _firestore;

  HistoryRemoteDataSource(this._firestore);

  /// Adds a new history record to the "histories" collection in Firestore
  @override
  Future<void> addHistoryToFirestore(HistoryModel history) async {
    await _firestore
        .collection("histories")
        .doc(history.historyId)
        .set(history.toMap());
  }

  /// Updates specified fields of a history document by its ID
  @override
  Future<void> updateHistoryData(
      String historyId, Map<String, dynamic> fieldsToUpdate) async {
    await _firestore
        .collection("histories")
        .doc(historyId)
        .update(fieldsToUpdate);
  }

  /// Queries Firestore to find an existing history record for a given
  /// [userId] and [videoId]. Returns the first matching document if found
  @override
  Future<HistoryModel?> findExistingHistoryDoc(
      String userId, String videoId) async {
    final query = await _firestore
        .collection("histories")
        .where("videoId", isEqualTo: videoId)
        .where("userId", isEqualTo: userId)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      return HistoryModel.fromMap(doc.data());
    }
    return null;
  }

  /// Retrieves a list of history records for a given user ID.
  /// The list is sorted by the "watchedAt" timestamp if [sortByLatest] is true
  @override
  Future<List<HistoryModel>> getMyVideoHistory(
      String userId, bool sortByLatest) async {
    final historySnapshot = await _firestore
        .collection("histories")
        .where("userId", isEqualTo: userId)
        .orderBy("watchedAt", descending: sortByLatest)
        .get();
    return historySnapshot.docs
        .map((doc) => HistoryModel.fromMap(doc.data()))
        .toList();
  }

  /// Deletes the Firestore document for a specific [historyId]
  @override
  Future<void> deleteHistoryFromFirestore(String historyId) async {
    await _firestore.collection("histories").doc(historyId).delete();
  }
}
