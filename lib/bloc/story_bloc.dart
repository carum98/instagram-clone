// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:instagram_clone/bloc/bloc.dart';
import 'package:instagram_clone/core/storie_repository.dart';
import 'package:instagram_clone/model/storie_model.dart';
import 'package:instagram_clone/model/user_model.dart';

class StoryBloc extends Bloc {
  final UserModel user;
  final StorieRepository repo;
  StoryBloc({required this.user, required this.repo});

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  List<StorieModel> _stories = [];
  List<StorieModel> get stories => _stories;

  final _pageController = StreamController<int>();
  final _storiesController = StreamController<List<StorieModel>>();

  Stream<int> get storyStream => _pageController.stream;
  Function(int) get changeStory => _pageController.sink.add;

  Stream<List<StorieModel>> get storiesStream => _storiesController.stream;
  Function(List<StorieModel>) get changeStories => _storiesController.sink.add;

  @override
  void dispose() {
    _pageController.close();
  }

  void getStories() async {
    final stories = await repo.getStories(user);
    _stories = stories;
    changeStories(stories);
  }
}
