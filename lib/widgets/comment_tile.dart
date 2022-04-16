import 'package:flutter/material.dart';
import 'package:instagram_clone/model/comment_model.dart';
import 'package:instagram_clone/routers/router_names.dart';
import 'package:instagram_clone/widgets/user_photo.dart';

import 'package:timeago/timeago.dart' as timeago;

class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final bool? isLiked;
  final Function(CommentModel) onLike;
  const CommentTile({Key? key, required this.comment, required this.onLike, this.isLiked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: UserPhoto(
            photoUrl: comment.user.photoUrl,
            size: 20,
          ),
          onTap: () => Navigator.of(context).pushNamed(PROFILE, arguments: comment.user),
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
        if (isLiked != null)
          GestureDetector(
            onTap: () => onLike(comment),
            child: isLiked!
                ? const Icon(Icons.favorite, color: Colors.red, size: 15)
                : const Icon(Icons.favorite_border_outlined, color: Colors.grey, size: 15),
          ),
      ],
    );
  }
}
