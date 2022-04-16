import 'package:flutter/material.dart';

class UserPhoto extends StatelessWidget {
  final String photoUrl;
  final double size;
  const UserPhoto({Key? key, required this.photoUrl, this.size = 15}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color.fromARGB(255, 186, 86, 55),
      radius: size + 4,
      child: CircleAvatar(
        backgroundColor: Colors.black,
        radius: size + 2,
        child: CircleAvatar(
          backgroundImage: NetworkImage(photoUrl),
          radius: size,
        ),
      ),
    );
  }
}
