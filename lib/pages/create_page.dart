import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_clone/core/post_repository.dart';
import 'package:instagram_clone/core/reel_repository.dart';
import 'package:instagram_clone/core/storie_repository.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:provider/provider.dart' hide Create;

enum Create { post, story, reel }

class CreatePage extends StatefulWidget {
  final Create type;
  const CreatePage({Key? key, required this.type}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final List<File?> _images = [];
  File? _selected;

  @override
  void initState() {
    super.initState();

    getImage();
  }

  void getImage() async {
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
    final List<AssetEntity> assets = await paths[0].getAssetListRange(start: 0, end: 20);

    final fileFuture = assets.map((e) => e.file);
    final files = await Future.wait(fileFuture);

    setState(() {
      _images.addAll(files);
      _selected = files.first;
    });
  }

  void send() async {
    final image = await _selected!.readAsBytes();
    final user = context.read<UserProvider>().user;
    String? footer;

    if ([Create.post, Create.reel].contains(widget.type)) {
      footer = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => _Footer(image: _selected!)),
      );
    }

    switch (widget.type) {
      case Create.post:
        await PostRepository().createPost(
          post: footer!,
          image: image,
          user: user,
        );
        break;
      case Create.story:
        await StorieRepository().createStorie(
          image: image,
          user: user,
        );
        break;
      case Create.reel:
        await ReelRepository().createReel(
          post: footer!,
          image: image,
          user: user,
        );
        break;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva publicación'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.blue),
            onPressed: send,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: _selected != null ? Image.file(_selected!, fit: BoxFit.cover) : Container(),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                Text('Galería'),
                Icon(Icons.keyboard_arrow_down),
                Spacer(),
                Icon(Icons.layers),
                SizedBox(width: 10),
                Icon(Icons.camera_alt_outlined),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final image = _images[index];
                return image == null
                    ? const SizedBox(width: 64, height: 64)
                    : GestureDetector(
                        child: Image.file(image, fit: BoxFit.cover),
                        onTap: () {
                          setState(() {
                            _selected = image;
                          });
                        });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final File image;
  const _Footer({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _footer = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva publicación'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () => Navigator.pop(context, _footer),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.file(image, fit: BoxFit.cover, width: 50, height: 50),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Escribe un pie de foto o video...',
                ),
                onChanged: (value) => _footer = value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
