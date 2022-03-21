import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/model/user_model.dart';

import 'package:uuid/uuid.dart';

class PostRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<void> createPost({
    required String post,
    required UserModel user,
    required Uint8List? image,
  }) async {
    try {
      String url = '';
      if (image != null) {
        const uuid = Uuid();
        String fileName = '${uuid.v4()}.jpg';
        Reference reference = _storage.ref('posts').child(user.uid).child(fileName);

        UploadTask uploadTask = reference.putData(image);
        TaskSnapshot taskSnapshot = await uploadTask;

        url = await taskSnapshot.ref.getDownloadURL();
      }

      final model = PostModel(
        imageUrl: url,
        post: post,
        likes: [],
        createdAt: DateTime.now(),
        user: user,
      );

      await _store.collection('posts').add(model.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<List<PostModel>> getPosts() async {
    try {
      QuerySnapshot querySnapshot = await _store.collection('posts').get();

      final List<UserModel> users = [];
      final List<PostModel> posts = [];

      for (DocumentSnapshot doc in querySnapshot.docs) {
        final userId = (doc.data() as Map<String, dynamic>)['userId'] as String;
        UserModel user;

        if (!users.any((user) => user.uid == userId)) {
          final userDoc = await _store.collection('users').doc(userId).get();

          final userRaw = userDoc.data() as Map<String, dynamic>;
          user = UserModel.fromMap(userRaw);

          users.add(user);
        } else {
          user = users.firstWhere((user) => user.uid == userId);
        }

        posts.add(PostModel.fromMap(doc.data() as Map<String, dynamic>, user));
      }

      return posts;
    } catch (e) {
      print(e);

      return [];
    }
  }
}
