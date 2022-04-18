import 'dart:convert';

import 'package:instagram_clone/model/user_model.dart';

class StorieModel {
  final String? uid;
  final String imageUrl;
  final DateTime createdAt;
  final UserModel user;

  StorieModel({
    this.uid,
    required this.imageUrl,
    required this.createdAt,
    required this.user,
  });

  StorieModel copyWith({
    String? uid,
    String? imageUrl,
    DateTime? createdAt,
    UserModel? user,
  }) {
    return StorieModel(
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'user': user.uid,
    };
  }

  factory StorieModel.fromMap(Map<String, dynamic> map, UserModel user) {
    return StorieModel(
      uid: map['uid'],
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      user: user,
    );
  }

  @override
  String toString() {
    return 'StorieModel(uid: $uid, imageUrl: $imageUrl, createdAt: $createdAt, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StorieModel &&
        other.uid == uid &&
        other.imageUrl == imageUrl &&
        other.createdAt == createdAt &&
        other.user == user;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ imageUrl.hashCode ^ createdAt.hashCode ^ user.hashCode;
  }
}
