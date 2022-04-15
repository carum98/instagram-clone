import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/comment_model.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/model/user_model.dart';

class CommentRepository {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<void> createComment({
    required String comment,
    required UserModel user,
    required PostModel post,
  }) async {
    try {
      final model =
          CommentModel(content: comment, createdAt: DateTime.now(), likes: [], user: user);

      final response = await _store.collection('comments').add(model.toMap());
      final id = response.id;

      _store.collection('posts').doc(post.uid).update({
        'comments':
            post.comments.contains(id) ? FieldValue.arrayRemove([id]) : FieldValue.arrayUnion([id]),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> likeComment({required CommentModel comment, required UserModel user}) async {
    try {
      await _store.collection('comments').doc(comment.uid).update({
        'likes': comment.likes.contains(user.uid)
            ? FieldValue.arrayRemove([user.uid])
            : FieldValue.arrayUnion([user.uid]),
      });
    } catch (e) {
      print(e);
    }
  }
}
