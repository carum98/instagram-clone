import 'package:flutter/foundation.dart';
import 'package:instagram_clone/model/user_model.dart';

class ReelModel {
  String? uid;
  final String imageUrl, post;
  final DateTime createdAt;
  final UserModel user;
  final List<String> likes, comments;

  ReelModel({
    this.uid,
    required this.imageUrl,
    required this.post,
    required this.createdAt,
    required this.user,
    required this.likes,
    required this.comments,
  });

  ReelModel copyWith({
    String? imageUrl,
    post,
    DateTime? createdAt,
    UserModel? user,
    List<String>? likes,
    comments,
  }) {
    return ReelModel(
      uid: uid,
      imageUrl: imageUrl ?? this.imageUrl,
      post: post ?? this.post,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'post': post,
      'createdAt': createdAt.toIso8601String(),
      'user': user.uid,
      'comments': comments,
      'likes': likes,
    };
  }

  factory ReelModel.fromMap(Map<String, dynamic> map, UserModel user) {
    return ReelModel(
      uid: map['uid'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      post: map['post'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      user: user,
      likes: List<String>.from(map['likes']),
      comments: List<String>.from(map['comments']),
    );
  }

  @override
  String toString() {
    return 'ReelModel(uid: $uid, imageUrl: $imageUrl, createdAt: $createdAt, user: $user, comments: $comments)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReelModel &&
        other.uid == uid &&
        other.imageUrl == imageUrl &&
        other.post == post &&
        other.createdAt == createdAt &&
        other.user == user &&
        listEquals(other.comments, comments);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        imageUrl.hashCode ^
        post.hashCode ^
        createdAt.hashCode ^
        user.hashCode ^
        comments.hashCode;
  }
}
