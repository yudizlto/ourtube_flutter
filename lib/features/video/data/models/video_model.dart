import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String videoId;
  final String userId;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String visibilityType;
  final String type;
  final List<String> tags;
  final int likesCount;
  final int dislikesCount;
  final int viewsCount;
  final int duration;
  final bool commentsEnabled;
  final int commentsCount;
  final bool audienceRestricted;
  final bool ageRestricted;
  final DateTime uploadedAt;

  VideoModel({
    required this.videoId,
    required this.userId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.visibilityType,
    required this.type,
    required this.tags,
    required this.likesCount,
    required this.dislikesCount,
    required this.viewsCount,
    required this.duration,
    required this.commentsEnabled,
    required this.commentsCount,
    required this.audienceRestricted,
    required this.ageRestricted,
    required this.uploadedAt,
  });

  // From Firestore
  factory VideoModel.fromMap(Map<String, dynamic> data) {
    return VideoModel(
      videoId: data["videoId"],
      userId: data["userId"],
      title: data["title"],
      description: data["description"],
      videoUrl: data["videoUrl"],
      thumbnailUrl: data["thumbnailUrl"],
      visibilityType: data["visibilityType"],
      type: data["type"],
      tags: List<String>.from(data["tags"]),
      likesCount: data["likesCount"],
      dislikesCount: data["dislikesCount"],
      viewsCount: data["viewsCount"],
      duration: data["duration"],
      commentsEnabled: data["commentsEnabled"],
      commentsCount: data["commentsCount"],
      audienceRestricted: data["audienceRestricted"],
      ageRestricted: data["ageRestricted"],
      uploadedAt: (data["uploadedAt"] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      "videoId": videoId,
      "userId": userId,
      "title": title,
      "description": description,
      "videoUrl": videoUrl,
      "thumbnailUrl": thumbnailUrl,
      "visibilityType": visibilityType,
      "type": type,
      "tags": tags,
      "likesCount": likesCount,
      "dislikesCount": dislikesCount,
      "viewsCount": viewsCount,
      "duration": duration,
      "commentsEnabled": commentsEnabled,
      "commentsCount": commentsCount,
      "audienceRestricted": audienceRestricted,
      "ageRestricted": ageRestricted,
      "uploadedAt": uploadedAt,
    };
  }

  VideoModel copyWith({
    String? videoId,
    String? userId,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    String? visibilityType,
    String? type,
    List<String>? tags,
    int? likesCount,
    int? dislikesCount,
    int? viewsCount,
    int? duration,
    bool? commentsEnabled,
    int? commentsCount,
    bool? audienceRestricted,
    bool? ageRestricted,
    DateTime? uploadedAt,
  }) {
    return VideoModel(
      videoId: videoId ?? this.videoId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      visibilityType: visibilityType ?? this.visibilityType,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      duration: duration ?? this.duration,
      commentsEnabled: commentsEnabled ?? this.commentsEnabled,
      commentsCount: commentsCount ?? this.commentsCount,
      audienceRestricted: audienceRestricted ?? this.audienceRestricted,
      ageRestricted: ageRestricted ?? this.ageRestricted,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
