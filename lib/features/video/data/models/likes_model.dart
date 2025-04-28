import 'package:cloud_firestore/cloud_firestore.dart';

class LikesModel {
  final String likeId;
  final String userId;
  final String videoId;
  final DateTime createdAt;

  LikesModel({
    required this.likeId,
    required this.userId,
    required this.videoId,
    required this.createdAt,
  });

  factory LikesModel.fromMap(Map<String, dynamic> map) {
    return LikesModel(
      likeId: map["likeId"],
      userId: map["userId"],
      videoId: map["videoId"],
      createdAt: (map["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "likeId": likeId,
      "userId": userId,
      "videoId": videoId,
      "createdAt": createdAt,
    };
  }
}
