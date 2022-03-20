import 'package:flutter/material.dart';
import 'package:instagram_clone/core/auth.dart';
import 'package:instagram_clone/model/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Auth().logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder<UserModel>(
          future: Auth().getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _Profile(user: snapshot.data!);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  final UserModel user;
  const _Profile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              maxRadius: 40,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            const Spacer(),
            _buildCounter('Publicacioines', 15),
            const Spacer(),
            _buildCounter('Seguidores', 10),
            const Spacer(),
            _buildCounter('Seguidos', 20),
          ],
        ),
        const SizedBox(height: 10),
        Text(user.name),
        Text(user.bio)
      ],
    );
  }

  Widget _buildCounter(String label, int counter) {
    return Column(
      children: [
        Text(
          '$counter',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
