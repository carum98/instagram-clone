import 'package:flutter/material.dart';

class ReelsPage extends StatelessWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reels'),
        centerTitle: false,
      ),
      body: const Center(
        child: Text('Reels'),
      ),
    );
  }
}
