import 'package:flutter/foundation.dart';
import 'package:instagram_clone/model/user_model.dart';

class PostModel {
  final String? uid;
  final String imageUrl;
  final String post;
  final List<String> likes, comments;
  final DateTime createdAt;
  final UserModel user;

  PostModel({
    this.uid,
    required this.imageUrl,
    required this.post,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.user,
  });

  PostModel copyWith({
    String? uid,
    String? imageUrl,
    String? post,
    List<String>? likes,
    comments,
  }) {
    return PostModel(
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
      post: post ?? this.post,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt,
      user: user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': user.uid,
      'imageUrl': imageUrl,
      'post': post,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map, UserModel user) {
    return PostModel(
      uid: map['uid'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      post: map['post'] ?? '',
      likes: List<String>.from(map['likes']),
      comments: List<String>.from(map['comments']),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      user: user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel &&
        other.uid == uid &&
        other.imageUrl == imageUrl &&
        other.post == post &&
        listEquals(other.likes, likes) &&
        createdAt == other.createdAt &&
        user == other.user;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        imageUrl.hashCode ^
        post.hashCode ^
        likes.hashCode ^
        createdAt.hashCode ^
        user.hashCode;
  }
}
