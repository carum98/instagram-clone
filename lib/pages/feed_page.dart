import 'package:flutter/material.dart';
import 'package:instagram_clone/core/auth.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Text('Feed'),
      ),
    );
  }
}
