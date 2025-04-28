import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String historyId;
  final String userId;
  final String videoId;
  final DateTime watchedAt;
  final int durationWatched;
  final bool isCompleted;

  HistoryModel({
    required this.historyId,
    required this.userId,
    required this.videoId,
    required this.watchedAt,
    required this.durationWatched,
    required this.isCompleted,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      historyId: map["historyId"],
      userId: map["userId"],
      videoId: map["videoId"],
      watchedAt: (map["watchedAt"] as Timestamp).toDate(),
      durationWatched: map["durationWatched"] ?? 0,
      isCompleted: map["isCompleted"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "historyId": historyId,
      "userId": userId,
      "videoId": videoId,
      "watchedAt": watchedAt,
      "durationWatched": durationWatched,
      "isCompleted": isCompleted,
    };
  }
}
