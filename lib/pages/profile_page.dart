import 'package:flutter/material.dart';
import 'package:instagram_clone/core/auth.dart';
import 'package:instagram_clone/core/post_repository.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/widgets/user_photo.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final UserModel? user;
  const ProfilePage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = user ?? context.read<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: Text(_user.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: const Icon(Icons.menu),
            itemBuilder: (_) => const [
              PopupMenuItem(
                child: Text('Logout'),
                value: 'logout',
              ),
            ],
            onSelected: (v) {
              if (v == 'logout') Auth().logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _Profile(user: _user),
          _PostsGrid(user: _user),
        ],
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  final UserModel user;
  const _Profile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMain = context.read<UserProvider>().user.uid == user.uid;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserPhoto(
                photoUrl: user.photoUrl,
                size: 35,
              ),
              const SizedBox(width: 15),
              const Spacer(),
              _buildCounter('Publicaciones', 15),
              const Spacer(),
              _buildCounter('Seguidores', 10),
              const Spacer(),
              _buildCounter('Seguidos', 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(user.bio),
          Row(
            children: [
              if (isMain) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Editar perfil'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      side: BorderSide(color: Colors.grey[700]!),
                    ),
                  ),
                ),
              ],
              if (!isMain) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Seguir'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[800],
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Mensaje'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      side: BorderSide(color: Colors.grey[700]!),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.person_add),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.withOpacity(0.2),
                  side: BorderSide(color: Colors.grey[700]!),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCounter(String label, int counter) {
    return Column(
      children: [
        Text(
          '$counter',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _PostsGrid extends StatelessWidget {
  final UserModel user;
  const _PostsGrid({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostModel>>(
        future: PostRepository().getPosts(user: user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final posts = snapshot.data!;

            return Expanded(
              child: GridView.builder(
                itemCount: posts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (_, index) {
                  final post = posts[index];

                  return Image.network(
                    post.imageUrl,
                    fit: BoxFit.cover,
                  );
                },
              ),
            );
          }

          return Container();
        });
  }
}
