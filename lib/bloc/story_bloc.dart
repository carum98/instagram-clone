// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:instagram_clone/bloc/bloc.dart';

class StoryBloc extends Bloc {
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  final _storyController = StreamController<int>();

  Stream<int> get storyStream => _storyController.stream;
  Function(int) get changeStory => _storyController.sink.add;

  @override
  void dispose() {
    _storyController.close();
  }
}
