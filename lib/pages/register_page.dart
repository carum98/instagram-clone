import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/core/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String name, email, password, bio;
    Uint8List? image;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _ImagePicker(
              onImagePicked: (value) => image = value,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (value) => name = value,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) => email = value,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              onChanged: (value) => password = value,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Bio',
              ),
              onChanged: (value) => bio = value,
            ),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () {
                Auth().register(
                  name: name,
                  email: email,
                  password: password,
                  image: image,
                  bio: bio,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePicker extends StatefulWidget {
  final void Function(Uint8List) onImagePicked;
  const _ImagePicker({Key? key, required this.onImagePicked}) : super(key: key);

  @override
  State<_ImagePicker> createState() => __ImagePickerState();
}

class __ImagePickerState extends State<_ImagePicker> {
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      minRadius: 60,
      maxRadius: 60,
      backgroundImage: _image == null ? null : MemoryImage(_image!),
      child: IconButton(
        icon: const Icon(Icons.camera_alt),
        onPressed: () async {
          final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

          if (pickedFile != null) {
            _image = await pickedFile.readAsBytes();
            widget.onImagePicked(_image!);

            setState(() {});
          }
        },
      ),
    );
  }
}
