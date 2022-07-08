import 'package:advstory/advstory.dart';
import 'package:advstory/src/contants/enums.dart';
import 'package:advstory/src/controller/advstory_controller_impl.dart';
import 'package:flutter/material.dart';

/// Implementatiom of [AdvStoryPlayerController].
class AdvStoryPlayerControllerImpl extends AdvStoryControllerImpl
    implements AdvStoryPlayerController {
  @override
  Future<void> open(StoryPosition position) async {
    assert(
      !positionNotifier.shouldShowView.value,
      'Story view already showing!',
    );

    storyController = PageController(initialPage: position.story);
    positionNotifier
      ..initialPosition = position
      ..update(story: position.story, content: position.content)
      ..shouldShowView.value = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      positionNotifier.update(status: StoryStatus.play);
    });
  }

  @override
  void close() => positionNotifier.shouldShowView.value = false;

  @override
  bool get isShowing => positionNotifier.shouldShowView.value;
}
