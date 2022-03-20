import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/core/auth.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Auth().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user?.displayName ?? 'No name'),
            Text(user?.email ?? 'Not logged in'),
            if (user?.photoURL != null)
              CircleAvatar(
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
              ),
          ],
        ),
      ),
    );
  }
}
