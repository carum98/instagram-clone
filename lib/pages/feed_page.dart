import 'package:flutter/material.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:instagram_clone/provider/post_provider.dart';
import 'package:instagram_clone/routers/router_names.dart';
import 'package:instagram_clone/widgets/post_tile.dart';
import 'package:instagram_clone/widgets/user_photo.dart';
import 'package:provider/provider.dart' hide Create;

import 'package:instagram_clone/pages/create_page.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/logo.png'),
          height: 35,
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: const [
                    Text('Publicacion'),
                    Spacer(),
                    Icon(Icons.grid_on),
                  ],
                ),
                value: 'post',
              ),
              PopupMenuItem(
                child: Row(
                  children: const [
                    Text('Historia'),
                    Spacer(),
                    Icon(Icons.add_circle_outline),
                  ],
                ),
                value: 'story',
              ),
              PopupMenuItem(
                child: Row(
                  children: const [
                    Text('Reel'),
                    Spacer(),
                    Icon(Icons.movie_creation_outlined),
                  ],
                ),
                value: 'reel',
              ),
            ],
            onSelected: (v) {
              if (v == 'post') {
                Navigator.of(context).pushNamed(CREATE, arguments: Create.post);
              }
              if (v == 'story') {
                Navigator.of(context).pushNamed(CREATE, arguments: Create.story);
              }
              if (v == 'reel') {
                Navigator.of(context).pushNamed(CREATE, arguments: Create.reel);
              }
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: StreamBuilder<List<UserModel>>(
              stream: context.read<PostProvider>().usersStream,
              initialData: context.read<PostProvider>().users,
              builder: (context, snapshot) => SizedBox(
                height: 80,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    final user = snapshot.data![index];

                    return SizedBox(
                      width: 70,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: UserPhoto(photoUrl: user.photoUrl, size: 24),
                            onTap: () => Navigator.pushNamed(context, STORY, arguments: user),
                          ),
                          Expanded(
                            child: Text(
                              user.name,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          StreamBuilder<List<PostModel>>(
            stream: context.read<PostProvider>().postsStream,
            initialData: context.read<PostProvider>().posts,
            builder: (context, snapshot) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final post = snapshot.data![index];
                    return PostTile(post: post);
                  },
                  childCount: snapshot.data!.length,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
