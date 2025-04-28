import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String recipientId;
  final String type;
  final String? videoId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.recipientId,
    required this.type,
    this.videoId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  // From Firestore
  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      notificationId: data['notificationId'],
      recipientId: data['recipientId'],
      type: data['type'],
      videoId: data['videoId'],
      message: data['message'],
      isRead: data['isRead'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'recipientId': recipientId,
      'type': type,
      'videoId': videoId,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }
}
