import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/bloc/bloc_provider.dart';
import 'package:instagram_clone/bloc/story_bloc.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:instagram_clone/widgets/user_photo.dart';

class StoryPage extends StatefulWidget {
  final UserModel user;
  const StoryPage({Key? key, required this.user}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late PageController _pageController;
  late StoryBloc _bloc;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _bloc = StoryBloc();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _automaticNextPage();
      _pageController.addListener(_automaticNextPage);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    const stories = [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocProvider<StoryBloc>(
              bloc: _bloc,
              child: Expanded(
                child: Stack(
                  children: [
                    GestureDetector(
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, i) => _StoryView(color: stories[i]),
                        itemCount: stories.length,
                      ),
                      onTapUp: _onTabDown,
                    ),
                    _UserInformation(
                      user: widget.user,
                      storiesLength: stories.length,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const _MessageStory(),
          ],
        ),
      ),
    );
  }

  void _onTabDown(TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;

    if (dx < width / 3) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeIn,
      );
    } else if (dx > width * 2 / 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeIn,
      );
    }
  }

  void _automaticNextPage() {
    _timer?.cancel();

    _bloc.changeStory(_pageController.page!.round());

    _timer = Timer(const Duration(seconds: 5), () {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeIn,
      );
    });
  }
}

class _StoryBars extends StatefulWidget {
  final int storiesLength;
  const _StoryBars({Key? key, required this.storiesLength}) : super(key: key);

  @override
  State<_StoryBars> createState() => _StoryBarsState();
}

class _StoryBarsState extends State<_StoryBars> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 5));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: BlocProvider.of<StoryBloc>(context).storyStream,
        builder: (_, snapshot) {
          if (!snapshot.hasData) return Container();

          _animationController.reset();
          _animationController.forward();

          return Row(
            children: List.generate(
              widget.storiesLength,
              (index) => _StoryBar(
                watched: snapshot.data! >= index,
                active: snapshot.data == index,
                animationController: _animationController,
              ),
            ),
          );
        });
  }
}

class _StoryBar extends StatelessWidget {
  final AnimationController animationController;
  final bool watched, active;
  const _StoryBar({
    Key? key,
    required this.watched,
    required this.active,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchedColor = Colors.grey[300]!;
    final disableColor = Colors.grey[300]!.withOpacity(0.5);

    return Flexible(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) => Container(
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: watched ? watchedColor : disableColor,
            borderRadius: BorderRadius.circular(5),
            gradient: active
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [animationController.value, 0],
                    colors: [watchedColor, disableColor],
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _UserInformation extends StatelessWidget {
  final UserModel user;
  final int storiesLength;
  const _UserInformation({Key? key, required this.user, required this.storiesLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _StoryBars(storiesLength: storiesLength),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              UserPhoto(photoUrl: user.photoUrl),
              const SizedBox(width: 10),
              Text(
                user.name,
                style: const TextStyle(fontSize: 20),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StoryView extends StatelessWidget {
  final Color color;
  const _StoryView({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _MessageStory extends StatelessWidget {
  const _MessageStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                isDense: true,
                labelText: 'Escribe un mensaje',
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.favorite_border),
          const SizedBox(width: 10),
          const Icon(Icons.send_outlined),
        ],
      ),
    );
  }
}
