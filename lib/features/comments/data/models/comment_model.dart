import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String videoId;
  final String userId;
  final String text;
  final int likesCount;
  final int dislikesCount;
  final int repliesCount;
  final DateTime createdAt;
  final bool isEdited;

  CommentModel({
    required this.commentId,
    required this.videoId,
    required this.userId,
    required this.text,
    required this.likesCount,
    required this.dislikesCount,
    required this.repliesCount,
    required this.createdAt,
    required this.isEdited,
  });

  // From Firestore
  factory CommentModel.fromMap(Map<String, dynamic> data) {
    return CommentModel(
      commentId: data["commentId"],
      videoId: data["videoId"],
      userId: data["userId"],
      text: data["text"],
      likesCount: data["likesCount"],
      dislikesCount: data["dislikesCount"],
      repliesCount: data["repliesCount"],
      createdAt: (data["createdAt"] as Timestamp).toDate(),
      isEdited: data["isEdited"],
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      "commentId": commentId,
      "videoId": videoId,
      "userId": userId,
      "text": text,
      "likesCount": likesCount,
      "dislikesCount": dislikesCount,
      "repliesCount": repliesCount,
      "createdAt": createdAt,
      "isEdited": isEdited,
    };
  }
}
