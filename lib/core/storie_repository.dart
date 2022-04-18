import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/model/storie_model.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:uuid/uuid.dart';

class StorieRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<void> createStorie({
    required UserModel user,
    required Uint8List image,
  }) async {
    const uuid = Uuid();

    String fileName = '${uuid.v4()}.jpg';
    Reference reference = _storage.ref('stories').child(user.uid).child(fileName);

    UploadTask uploadTask = reference.putData(image);
    TaskSnapshot taskSnapshot = await uploadTask;

    final url = await taskSnapshot.ref.getDownloadURL();

    final model = StorieModel(
      imageUrl: url,
      user: user,
      createdAt: DateTime.now(),
    );

    await _store.collection('stories').add(model.toMap());
  }

  Future<List<StorieModel>> getStories(UserModel user) async {
    final snapshot = await _store.collection('stories').where('user', isEqualTo: user.uid).get();

    return snapshot.docs.map((doc) => StorieModel.fromMap(doc.data(), user)).toList();
  }
}
