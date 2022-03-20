import 'package:flutter/material.dart';

class StorePage extends StatelessWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        centerTitle: false,
      ),
      body: const Center(
        child: Text('Store'),
      ),
    );
  }
}
