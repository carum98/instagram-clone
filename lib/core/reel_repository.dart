import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/model/reel_model.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:uuid/uuid.dart';

class ReelRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<void> createReel({
    required UserModel user,
    required Uint8List image,
    required String post,
  }) async {
    const uuid = Uuid();

    String fileName = '${uuid.v4()}.jpg';
    Reference reference = _storage.ref('reels').child(user.uid).child(fileName);

    UploadTask uploadTask = reference.putData(image);
    TaskSnapshot taskSnapshot = await uploadTask;

    final url = await taskSnapshot.ref.getDownloadURL();

    final model = ReelModel(
      imageUrl: url,
      user: user,
      createdAt: DateTime.now(),
      post: post,
      comments: [],
      likes: [],
    );

    await _store.collection('reels').add(model.toMap());
  }

  Future<List<ReelModel>> getReels() async {
    final snapshot = await _store.collection('reels').get();
    List<ReelModel> reels = [];

    for (var reel in snapshot.docs) {
      final uid = reel['user'] as String;
      final user = await _store.collection('users').doc(uid).get();

      reels.add(ReelModel.fromMap(reel.data(), UserModel.fromMap(user.data()!)));
    }

    return reels;
  }
}
