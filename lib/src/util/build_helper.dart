import 'dart:async';
import 'dart:io';

import 'package:advstory/src/contants/types.dart';
import 'package:advstory/src/model/models.dart';
import 'package:advstory/src/util/binder.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Building, downloading and caching utility for media files.
class BuildHelper {
  /// Provides methods for loading and caching media files from the internet.
  /// Also, provides build methods for media items.
  BuildHelper({this.storyBuilder, this.cacheStories = true}) {
    _storyBuildStack = <int>[].bind(_builderStackHandler);
  }

  /// The builder function that will be called to build a [Story].
  StoryBuilder? storyBuilder;

  /// Determines if built stories should cache or not.
  final bool cacheStories;

  /// Stors the built stories.
  final stories = <int, Story>{};

  late final Binded<List<int>> _storyBuildStack;
  bool _hasPriorItem = false;

  /// Pauses story builds that has not priority, builds and returns required
  /// story first.
  Future<Story> buildStory(int index) async {
    if (!cacheStories) return storyBuilder!(index);

    if (!stories.containsKey(index)) {
      _hasPriorItem = true;
      await _buildStory(index);

      _hasPriorItem = false;
    }

    _storyBuildStack.update();

    return stories[index]!;
  }

  /// Builds story and caches it to memory to make it ready to display.
  void prepareStory(int index) {
    if (stories.containsKey(index)) return;

    _storyBuildStack.value = [..._storyBuildStack.value, index];
  }

  Future<void> _builderStackHandler(List<int> indexes) async {
    for (int i = 0; i < indexes.length; i++) {
      if (_hasPriorItem) return;

      final index = indexes.first;
      _storyBuildStack.value.removeAt(0);

      await _buildStory(index);
    }
  }

  Future<void> _buildStory(int index) async {
    stories[index] = await storyBuilder!.call(index);
  }

  /// Fetches media file from the internet and caches it to local storage.
  Future<File> getMediaFile({
    required String url,
    Map<String, String>? requestHeaders,
    String? cacheKey,
  }) {
    return DefaultCacheManager().getSingleFile(
      url,
      key: cacheKey ?? url,
      headers: requestHeaders,
    );
  }
}
