import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistModel {
  final String playlistId;
  final String userId;
  final String name;
  final String description;
  final List<String> videos;
  // final String thumbnailUrl;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PlaylistModel({
    required this.playlistId,
    required this.userId,
    required this.name,
    required this.description,
    required this.videos,
    // required this.thumbnailUrl,
    required this.isPublic,
    required this.createdAt,
    this.updatedAt,
  });

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      playlistId: map["playlistId"],
      userId: map["userId"],
      name: map["name"],
      description: map["description"] ?? "",
      videos: List<String>.from(map["videos"] ?? []),
      // thumbnailUrl: map["thumbnailUrl"] ?? "",
      isPublic: map["isPublic"] ?? true,
      createdAt: (map["createdAt"] as Timestamp).toDate(),
      updatedAt: map["updatedAt"] != null
          ? (map["updatedAt"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "playlistId": playlistId,
      "userId": userId,
      "name": name,
      "description": description,
      "videos": videos,
      // "thumbnailUrl": thumbnailUrl,
      "isPublic": isPublic,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
