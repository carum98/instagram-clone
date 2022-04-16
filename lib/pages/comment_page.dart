import 'package:flutter/material.dart';
import 'package:instagram_clone/core/comment_repository.dart';
import 'package:instagram_clone/model/comment_model.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:instagram_clone/provider/comment_provider.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/widgets/comment_tile.dart';
import 'package:instagram_clone/widgets/user_photo.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final PostModel post;
  const CommentPage({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late CommentProvider _provider;
  late UserModel _user;

  @override
  void initState() {
    super.initState();

    _user = context.read<UserProvider>().user;

    _provider = CommentProvider();
    _provider.fetchComments(widget.post);
  }

  @override
  void dispose() {
    super.dispose();

    _provider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String comment = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentarios'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomScrollView(
          slivers: [
            StreamBuilder<List<CommentModel>>(
              stream: _provider.commentsStream,
              initialData: _provider.comments,
              builder: (context, snapshot) {
                final comments = snapshot.data!;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      final comment = comments[index];
                      final isLiked = comment.likes.contains(_user.uid);

                      return CommentTile(
                        comment: comment,
                        onLike: likeComment,
                        isLiked: isLiked,
                      );
                    },
                    childCount: comments.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 130,
        color: Colors.grey[850],
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 10),
                Icon(Icons.tag_faces_rounded, color: Colors.yellow),
                SizedBox(width: 10),
                Icon(Icons.back_hand, color: Colors.yellow),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                UserPhoto(photoUrl: _user.photoUrl),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Agregar un comentario...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => comment = value,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    CommentRepository().createComment(
                      comment: comment,
                      user: _user,
                      post: widget.post,
                    );
                  },
                  child: const Text('Publicar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void likeComment(CommentModel comment) {
    CommentRepository().likeComment(comment: comment, user: _user);
  }
}
