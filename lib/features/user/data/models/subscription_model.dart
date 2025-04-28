import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  final String subscriptionId;
  // final String subscribedToId;
  final String userId;
  final String subscribedTo;
  final DateTime subscribedAt;

  SubscriptionModel({
    required this.subscriptionId,
    // required this.subscribedToId,
    required this.userId,
    required this.subscribedTo,
    required this.subscribedAt,
  });

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      subscriptionId: map["subscriptionId"],
      // subscribedToId: map["subscribedToId"],
      userId: map["userId"],
      subscribedTo: map["subscribedTo"],
      subscribedAt: (map["subscribedAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "subscriberId": subscriptionId,
      // "subscribedToId": subscribedToId,
      "userId": userId,
      "subscribedTo": subscribedTo,
      "subscribedAt": subscribedAt,
    };
  }
}
