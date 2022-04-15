import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/comment_model.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/model/user_model.dart';

class CommentProvider {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  final List<CommentModel> _comments = [];
  final List<UserModel> _users = [];

  StreamSubscription? _subscription;

  final _commentController = StreamController<List<CommentModel>>.broadcast();

  Function(List<CommentModel>) get commentsSink => _commentController.sink.add;
  Stream<List<CommentModel>> get commentsStream => _commentController.stream;

  void dispose() {
    _commentController.close();
    _subscription?.cancel();
  }

  List<CommentModel> get comments => _comments;

  Future<void> fetchComments(PostModel post) async {
    // Initial
    _getComments(post.comments);

    // New comment
    _store.collection('posts').doc(post.uid).snapshots().listen((snapshot) {
      final comments = List<String>.from((snapshot.data() as Map<String, dynamic>)['comments']);
      _getComments(comments);
    });
  }

  void _getComments(List<String> comments) async {
    if (comments.isEmpty) return;

    _subscription?.cancel();

    final snapshot =
        await _store.collection('comments').where(FieldPath.documentId, whereIn: comments).get();

    final data = snapshot.docs.map((e) {
      final map = e.data();
      map['uid'] = e.id;
      return map;
    }).toList();

    _onChange(data);

    // Listen liked comment
    _subscription = _store
        .collection('comments')
        .where(FieldPath.documentId, whereIn: comments)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.where((e) => e.type == DocumentChangeType.modified).forEach((e) {
        final likes = List<String>.from((e.doc.data() as Map<String, dynamic>)['likes']);
        _likeComment(e.doc.id, likes);
      });
    });
  }

  void _onChange(List<Map<String, dynamic>> commentsData) async {
    for (var comment in commentsData) {
      final userId = comment['userId'] as String;
      UserModel user;

      if (!_users.any((user) => user.uid == userId)) {
        final userDoc = await _store.collection('users').doc(userId).get();

        final userRaw = userDoc.data() as Map<String, dynamic>;
        user = UserModel.fromMap(userRaw);

        _users.add(user);
      } else {
        user = _users.firstWhere((user) => user.uid == userId);
      }

      final commentModel = CommentModel.fromMap(comment, user);
      if (!_comments.contains(commentModel)) _addComments(commentModel);
    }
  }

  void _addComments(CommentModel comments) {
    _comments.insert(0, comments);
    commentsSink(_comments);
  }

  void _likeComment(String commentId, List<String> likes) {
    final index = _comments.indexWhere((e) => e.uid == commentId);
    _comments[index] = _comments[index].copyWith(likes: likes);
    commentsSink(_comments);
  }
}
