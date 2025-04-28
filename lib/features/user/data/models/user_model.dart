import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String displayName;
  final String username;
  final String email;
  final String photoUrl;
  final String bannerUrl;
  final List<String> subscriptions;
  final List<String> subscribers;
  final List<String> videos;
  final String description;
  final DateTime createdAt;
  final int likedVideos;
  final int dislikedVideos;
  final List<String> playlists;

  UserModel({
    required this.userId,
    required this.displayName,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.bannerUrl,
    required this.subscriptions,
    required this.subscribers,
    required this.videos,
    required this.description,
    required this.createdAt,
    required this.likedVideos,
    required this.dislikedVideos,
    required this.playlists,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "userId": userId,
      "displayName": displayName,
      "username": username,
      "email": email,
      "photoUrl": photoUrl,
      "bannerUrl": bannerUrl,
      "subscriptions": subscriptions,
      "subscribers": subscribers,
      "videos": videos,
      "description": description,
      "createdAt": createdAt,
      "likedVideos": likedVideos,
      "dislikedVideos": dislikedVideos,
      "playlists": playlists,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map["userId"],
      displayName: map["displayName"],
      username: map["username"],
      email: map["email"],
      photoUrl: map["photoUrl"],
      bannerUrl: map["bannerUrl"],
      subscriptions: List<String>.from(map["subscriptions"] ?? []),
      subscribers: List<String>.from(map["subscribers"] ?? []),
      videos: List<String>.from(map["videos"] ?? []),
      description: map["description"],
      createdAt: (map["createdAt"] as Timestamp).toDate(),
      likedVideos: map["likedVideos"],
      dislikedVideos: map["dislikedVideos"],
      playlists: List<String>.from(map["playlists"] ?? []),
    );
  }
}
