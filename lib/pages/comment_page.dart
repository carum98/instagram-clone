import 'package:flutter/material.dart';
import 'package:instagram_clone/core/comment_repository.dart';
import 'package:instagram_clone/model/comment_model.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:instagram_clone/provider/comment_provider.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../routers/router_names.dart';

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
      body: SafeArea(
        child: Column(children: [
          StreamBuilder<List<CommentModel>>(
            stream: _provider.commentsStream,
            initialData: _provider.comments,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  final comment = snapshot.data![index];
                  final isLiked = comment.likes.contains(_user.uid);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(comment.user.photoUrl),
                        ),
                        onTap: () =>
                            Navigator.of(context).pushNamed(PROFILE, arguments: comment.user),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '${comment.user.name} ',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                children: [
                                  TextSpan(
                                      text: comment.content,
                                      style: const TextStyle(fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  timeago.format(comment.createdAt),
                                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  '${comment.likes.length} Me gusta',
                                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Responder',
                                  style: TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25)
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => likeComment(comment),
                        child: isLiked
                            ? const Icon(Icons.favorite, color: Colors.red, size: 15)
                            : const Icon(Icons.favorite_border_outlined, size: 15),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const Spacer(),
          Container(
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
                    CircleAvatar(
                      backgroundImage: NetworkImage(_user.photoUrl),
                    ),
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
        ]),
      ),
    );
  }

  void likeComment(CommentModel comment) {
    CommentRepository().likeComment(comment: comment, user: _user);
  }
}
