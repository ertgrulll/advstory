import 'package:advstory/advstory.dart';
import 'package:advstory/src/model/types/story.dart';
import 'package:advstory/src/view/data_provider.dart';
import 'package:flutter/material.dart';

/// Base class for story views.
abstract class StoryItem extends StatefulWidget {
  const StoryItem({
    required this.story,
    required this.position,
    Key? key,
  }) : super(key: key);

  /// Index of the story in the cluster. Used to determine if story is showing
  /// or not.
  final StoryPosition position;

  /// Story params to creating view.
  final Story story;

  @override
  StoryItemState createState();
}

/// State for [StoryItem].
abstract class StoryItemState<T extends StoryItem, R> extends State<T> {
  late DataProvider _provider;
  late final Widget loadingScreen;
  R? resource;

  @override
  void didChangeDependencies() {
    _provider = DataProvider.of(context)!;
    loadingScreen = _provider.style();

    _provider.getResource<R>(widget.story, widget.position).then((value) {
      if (mounted) {
        setState(() {
          resource = value;
        });
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _provider.cleanUp(widget.position);
    super.dispose();
  }
}
