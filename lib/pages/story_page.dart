import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/bloc/bloc_provider.dart';
import 'package:instagram_clone/bloc/story_bloc.dart';
import 'package:instagram_clone/core/storie_repository.dart';
import 'package:instagram_clone/model/storie_model.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:instagram_clone/widgets/user_photo.dart';

class StoryPage extends StatelessWidget {
  final UserModel user;
  const StoryPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StoryBloc(
      user: user,
      repo: StorieRepository(),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocProvider<StoryBloc>(
              bloc: bloc,
              child: Expanded(
                child: Stack(
                  children: [
                    const _StoryList(),
                    _UserInformation(user: user),
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
}

class _StoryList extends StatefulWidget {
  const _StoryList({Key? key}) : super(key: key);

  @override
  State<_StoryList> createState() => __StoryListState();
}

class __StoryListState extends State<_StoryList> {
  late PageController _pageController;
  late StoryBloc _bloc;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _bloc = BlocProvider.of<StoryBloc>(context);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _automaticNextPage();
      _pageController.addListener(_automaticNextPage);
      _bloc.getStories();
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
    return GestureDetector(
      child: StreamBuilder<List<StorieModel>>(
        stream: _bloc.storiesStream,
        initialData: _bloc.stories,
        builder: (_, snapshot) => PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) => _StoryView(story: snapshot.data![i]),
          itemCount: snapshot.data!.length,
        ),
      ),
      onTapUp: _onTabDown,
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
  const _StoryBars({Key? key}) : super(key: key);

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
              BlocProvider.of<StoryBloc>(context).stories.length,
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
  const _UserInformation({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: _StoryBars(),
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
  final StorieModel story;
  const _StoryView({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image(
        image: NetworkImage(story.imageUrl),
        fit: BoxFit.cover,
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
