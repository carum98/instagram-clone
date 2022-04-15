import 'package:flutter/foundation.dart';
import 'package:instagram_clone/model/user_model.dart';

class CommentModel {
  final String? uid;
  final String content;
  final DateTime createdAt;
  final List<String> likes;
  final UserModel user;

  CommentModel({
    this.uid,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.user,
  });

  CommentModel copyWith({
    String? uid,
    String? content,
    DateTime? createdAt,
    List<String>? likes,
    UserModel? user,
  }) {
    return CommentModel(
        uid: uid ?? this.uid,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        likes: likes ?? this.likes,
        user: user ?? this.user);
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'userId': user.uid,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map, UserModel user) {
    return CommentModel(
        uid: map['uid'],
        content: map['content'],
        createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
        likes: List<String>.from(map['likes']),
        user: user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel &&
        other.uid == uid &&
        other.content == content &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        createdAt == other.createdAt &&
        user == other.user;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ content.hashCode ^ likes.hashCode ^ createdAt.hashCode ^ user.hashCode;
  }
}
