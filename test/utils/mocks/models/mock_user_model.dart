import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

class MockUserModel extends Mock {
  final String? userId;
  final String? displayName;
  final String? username;
  final String? email;
  final String? photoUrl;
  final String? bannerUrl;
  final List<String>? subscriptions;
  final List<String>? subscribers;
  final List<String>? videos;
  final String? description;
  final DateTime? createdAt;
  final int? likedVideos;
  final int? dislikedVideos;
  final List<String>? playlists;

  MockUserModel({
    this.userId,
    this.displayName,
    this.username,
    this.email,
    this.photoUrl,
    this.bannerUrl,
    this.subscriptions,
    this.subscribers,
    this.videos,
    this.description,
    this.createdAt,
    this.likedVideos,
    this.dislikedVideos,
    this.playlists,
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

  factory MockUserModel.fromMap(Map<String, dynamic> map) {
    return MockUserModel(
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
