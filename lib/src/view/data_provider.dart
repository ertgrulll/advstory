import 'package:advstory/src/controller/flow_manager.dart';
import 'package:advstory/src/controller/story_controller_impl.dart';
import 'package:advstory/src/model/models.dart';
import 'package:advstory/src/model/story_resource.dart';
import 'package:advstory/src/model/types/story.dart';
import 'package:advstory/src/util/build_helper.dart';
import 'package:advstory/src/view/components/items/image_item.dart';
import 'package:advstory/src/view/components/items/story_item.dart';
import 'package:advstory/src/view/components/items/video_item.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Acts like a middleware between the story controller and the story items.
/// Provides data to the items and notifies controller to starting flow.
class DataProvider extends InheritedWidget {
  const DataProvider({
    Key? key,
    required Widget child,
    required this.controller,
    required this.clusterCount,
    required this.style,
    required this.buildHelper,
    required this.initialPosition,
    required this.initialPositionStarted,
    required this.hideBars,
  }) : super(key: key, child: child);

  final bool hideBars;
  final AdvStoryControllerImpl controller;
  final AdvStoryStyle style;
  final int clusterCount;
  final BuildHelper buildHelper;
  final StoryPosition initialPosition;
  final ValueNotifier<bool> initialPositionStarted;

  /// Provides required resource to the [StoryItem]'s and updates load status.
  /// This update causes the [FlowManager] start method to trigger.
  Future<R> getResource<R>(Story story, StoryPosition position) async {
    R resource;

    if (story is VideoStory) {
      resource = await _getVideoController(story, position) as R;
    } else if (story is ImageStory) {
      resource = await _getImage(story, position) as R;
    } else {
      resource = null as R;
    }

    if (!initialPositionStarted.value && position == initialPosition) {
      controller.flowManager.start(position);
      initialPositionStarted.value = true;
    }

    return resource;
  }

  /// Loads file and returns [ImageProvider] for the [ImageItem].
  Future<ImageProvider<FileImage>> _getImage(
    ImageStory story,
    StoryPosition position,
  ) async {
    final storedResource =
        controller.flowManager.getResource<ImageResource>(position);
    if (storedResource != null) {
      return storedResource.image!;
    }

    final resource = ImageResource();

    controller.flowManager.addResource(resource, position);

    final file = await buildHelper.getMediaFile(
      url: story.url,
      headers: story.requestHeaders,
      key: story.cacheKey,
    );

    resource.image = FileImage(file);
    resource.isLoaded.value = true;

    return resource.image!;
  }

  /// Loads file and returns [VideoPlayerController] for the [VideoItem].
  Future<VideoPlayerController> _getVideoController(
    VideoStory story,
    StoryPosition position,
  ) async {
    final storedResource =
        controller.flowManager.getResource<VideoResource>(position);
    if (storedResource != null) {
      return storedResource.videoController!;
    }

    final resource = VideoResource();
    controller.flowManager.addResource(resource, position);

    final file = await buildHelper.getMediaFile(
      url: story.url,
      headers: story.requestHeaders,
      key: story.cacheKey,
    );

    final videoController = VideoPlayerController.file(file);
    await videoController.initialize();

    resource.videoController = videoController;
    resource.isLoaded.value = true;

    return videoController;
  }

  /// Removes the resource from the [FlowManager] and releases the resources.
  void cleanUp(StoryPosition position) {
    controller.flowManager.removeResource(position);
  }

  /// Returns the [DataProvider] from the [BuildContext].
  static DataProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProvider>();
  }

  @override
  bool updateShouldNotify(DataProvider oldWidget) => false;
}
