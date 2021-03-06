import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/model/user_model.dart';

class PostProvider {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final List<PostModel> _posts = [];
  final List<UserModel> _usersTmp = [], _users = [];

  final _postController = StreamController<List<PostModel>>.broadcast();
  final _userController = StreamController<List<UserModel>>.broadcast();

  Function(List<PostModel>) get postSink => _postController.sink.add;
  Stream<List<PostModel>> get postsStream => _postController.stream;

  Function(List<UserModel>) get userSink => _userController.sink.add;
  Stream<List<UserModel>> get usersStream => _userController.stream;

  void dispose() {
    _postController.close();
    _userController.close();
  }

  List<PostModel> get posts => _posts;
  List<UserModel> get users => _users;

  Future<void> fetchPosts() async {
    _store.collection('posts').orderBy('createdAt').snapshots().listen((snapshot) {
      final added = snapshot.docChanges.where((e) => e.type == DocumentChangeType.added).map((e) {
        final map = e.doc.data() as Map<String, dynamic>;
        map['uid'] = e.doc.id;
        return map;
      }).toList();

      if (added.isNotEmpty) {
        _onChange(added);
      }

      snapshot.docChanges.where((e) => e.type == DocumentChangeType.modified).forEach((e) {
        final likes = List<String>.from((e.doc.data() as Map<String, dynamic>)['likes']);
        final comments = List<String>.from((e.doc.data() as Map<String, dynamic>)['comments']);
        _likePost(e.doc.id, likes, comments);
      });
    });
  }

  void fetchStoriesStories() {
    _store.collection('stories').snapshots().listen((snapshot) async {
      final added = snapshot.docChanges
          .where((e) => e.type == DocumentChangeType.added)
          .map((e) => e.doc.data() as Map<String, dynamic>)
          .toList();

      for (var storie in added) {
        final userId = storie['user'] as String;
        final user = await _getUser(userId);

        if (!_users.contains(user)) _addUsers(user);
      }
    });
  }

  Future<UserModel> _getUser(String uid) async {
    UserModel user;

    if (!_usersTmp.any((user) => user.uid == uid)) {
      final userDoc = await _store.collection('users').doc(uid).get();

      final userRaw = userDoc.data() as Map<String, dynamic>;
      user = UserModel.fromMap(userRaw);

      _usersTmp.add(user);
    } else {
      user = _usersTmp.firstWhere((user) => user.uid == uid);
    }

    return user;
  }

  void _onChange(List<Map<String, dynamic>> postData) async {
    for (var post in postData) {
      final userId = post['userId'] as String;
      final user = await _getUser(userId);

      final postModel = PostModel.fromMap(post, user);
      if (!_posts.contains(postModel)) _addPosts(postModel);
    }
  }

  void _addPosts(PostModel post) {
    _posts.insert(0, post);
    postSink(_posts);
  }

  void _addUsers(UserModel user) {
    _users.insert(0, user);
    userSink(_users);
  }

  void _likePost(String postId, List<String> likes, comments) {
    final index = _posts.indexWhere((e) => e.uid == postId);
    _posts[index] = _posts[index].copyWith(likes: likes, comments: comments);
    postSink(_posts);
  }
}
