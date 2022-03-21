import 'package:flutter/material.dart';
import 'package:instagram_clone/core/post_repository.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/routers/router_names.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<PostModel>>(
          future: PostRepository().getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(backgroundImage: NetworkImage(post.user.photoUrl)),
                            Text(post.user.name),
                          ],
                        ),
                      ),
                      Image(
                        image: NetworkImage(post.imageUrl),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.post),
                            Text('${post.likes.length} likes'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
