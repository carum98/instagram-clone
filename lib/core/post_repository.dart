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

  Future<List<PostModel>> getPosts({required UserModel user}) async {
    try {
      final snapshot = await _store.collection('posts').where('userId', isEqualTo: user.uid).get();
      return snapshot.docs.map((doc) => PostModel.fromMap(doc.data(), user)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> likePost({required PostModel post, required UserModel user}) async {
    try {
      await _store.collection('posts').doc(post.uid).update({
        'likes': post.likes.contains(user.uid)
            ? FieldValue.arrayRemove([user.uid])
            : FieldValue.arrayUnion([user.uid]),
      });
    } catch (e) {
      print(e);
    }
  }
}
