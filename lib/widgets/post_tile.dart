import 'package:flutter/material.dart';
import 'package:instagram_clone/core/post_repository.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/routers/router_names.dart';
import 'package:instagram_clone/widgets/user_photo.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

class PostTile extends StatelessWidget {
  final PostModel post;
  const PostTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLiked = post.likes.contains(context.read<UserProvider>().user.uid);

    void _like(PostModel post) {
      PostRepository().likePost(
        post: post,
        user: context.read<UserProvider>().user,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              GestureDetector(
                child: UserPhoto(photoUrl: post.user.photoUrl),
                onTap: () => Navigator.of(context).pushNamed(PROFILE, arguments: post.user),
              ),
              const SizedBox(width: 8),
              Text(post.user.name, style: const TextStyle(fontSize: 13)),
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
              GestureDetector(
                child: Text(
                  'Show ${post.comments.length} comments',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () => Navigator.of(context).pushNamed(COMMENT, arguments: post),
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
  }
}
