import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/core/storie_repository.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CreateStoriePage extends StatelessWidget {
  const CreateStoriePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List? _image;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              StorieRepository().createStorie(
                user: context.read<UserProvider>().user,
                image: _image!,
              );

              Navigator.pop(context);
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
      body: Column(
        children: [
          _ImagePicker(
            onImagePicked: (value) => _image = value,
          ),
        ],
      ),
    );
  }
}

class _ImagePicker extends StatefulWidget {
  final Function(Uint8List) onImagePicked;
  const _ImagePicker({Key? key, required this.onImagePicked}) : super(key: key);

  @override
  State<_ImagePicker> createState() => __ImagePickerState();
}

class __ImagePickerState extends State<_ImagePicker> {
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_image != null) Image.memory(_image!),
        ElevatedButton(
          child: const Text('Pick image'),
          onPressed: () async {
            final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

            if (pickedFile != null) {
              _image = await pickedFile.readAsBytes();
              widget.onImagePicked(_image!);

              setState(() {});
            }
          },
        ),
      ],
    );
  }
}
