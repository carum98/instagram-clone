import 'package:flutter/material.dart';
import 'package:instagram_clone/core/post_repository.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/provider/post_provider.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/routers/router_names.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _like(PostModel post) {
      PostRepository().likePost(
        post: post,
        user: context.read<UserProvider>().user,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram'),
        centerTitle: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => const [
              PopupMenuItem(
                child: Text('Publicacion'),
                value: 'post',
              ),
              PopupMenuItem(
                child: Text('Historial'),
                value: 'history',
              ),
              PopupMenuItem(
                child: Text('Reel'),
                value: 'reel',
              ),
              PopupMenuItem(
                child: Text('Video en vivo'),
                value: 'live',
              ),
            ],
            onSelected: (v) {
              if (v == 'post') {
                Navigator.of(context).pushNamed(CREATE_POST);
              }
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<List<PostModel>>(
        stream: context.read<PostProvider>().postsStream,
        initialData: context.read<PostProvider>().posts,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];
              final isLiked = post.likes.contains(context.read<UserProvider>().user.uid);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(post.user.photoUrl),
                          ),
                          onTap: () =>
                              Navigator.of(context).pushNamed(PROFILE, arguments: post.user),
                        ),
                        const SizedBox(width: 8),
                        Text(post.user.name),
                        const Spacer(),
                        const Icon(Icons.more_vert),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Image(
                      image: NetworkImage(post.imageUrl),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    onDoubleTap: () => _like(post),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _like(post),
                              child: isLiked
                                  ? const Icon(Icons.favorite, color: Colors.red)
                                  : const Icon(Icons.favorite_border_outlined),
                            ),
                            const SizedBox(width: 15),
                            const Icon(Icons.comment_outlined),
                            const SizedBox(width: 15),
                            const Icon(Icons.send_outlined),
                            const Spacer(),
                            const Icon(Icons.bookmark_border_outlined),
                          ],
                        ),
                        Text('${post.likes.length} likes'),
                        Text(post.post),
                        Text(
                          'Show ${[].length} comments',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          timeago.format(post.createdAt),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
