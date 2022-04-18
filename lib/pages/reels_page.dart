import 'package:flutter/material.dart';
import 'package:instagram_clone/core/reel_repository.dart';
import 'package:instagram_clone/model/reel_model.dart';
import 'package:instagram_clone/widgets/user_photo.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReelsPage extends StatelessWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<ReelModel>>(
          future: ReelRepository().getReels(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return PageView(
              scrollDirection: Axis.vertical,
              children: snapshot.data!.map((reel) {
                return _Reel(reel: reel);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _Reel extends StatelessWidget {
  final ReelModel reel;
  const _Reel({Key? key, required this.reel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image(
            image: NetworkImage(reel.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        const Positioned(
          top: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.camera_alt_outlined),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          UserPhoto(photoUrl: reel.user.photoUrl),
                          const SizedBox(width: 10),
                          Text(reel.user.name),
                          const SizedBox(width: 10),
                          Text(
                            timeago.format(reel.createdAt),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 20,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Seguir'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent,
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(reel.post),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite_border),
                    Text('${reel.likes.length}'),
                    const SizedBox(height: 20),
                    const Icon(Icons.comment_outlined),
                    Text('${reel.comments.length}'),
                    const SizedBox(height: 20),
                    const Icon(Icons.send_outlined),
                    const SizedBox(height: 20),
                    const Icon(Icons.more_vert),
                    const SizedBox(height: 20),
                    const Icon(Icons.crop_square)
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
