import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/model/user_model.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String bio,
    required Uint8List? image,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      userCredential.user!.updateDisplayName(name);

      if (image != null) {
        Reference reference =
            _storage.ref('users').child(userCredential.user!.uid).child('profile.jpg');

        UploadTask uploadTask = reference.putData(image);
        TaskSnapshot taskSnapshot = await uploadTask;

        final url = await taskSnapshot.ref.getDownloadURL();

        userCredential.user!.updatePhotoURL(url);
      }

      final user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        photoUrl: userCredential.user!.photoURL ?? '',
        bio: bio,
      );

      _store.collection('users').doc(user.uid).set(user.toMap());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
