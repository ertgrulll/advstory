import 'dart:io';

import 'package:advstory/advstory.dart';
import 'package:example/mock_story_data.dart';
import 'package:flutter/material.dart';

/// Example of advanced custom story contents.
///
/// [AdvStory] exposes [StoryContent] class which is also superclass of
/// [ImageContent] and [VideoContent]. This means you can use any [AdvStory]
/// method to create your own story content, just like predefined contents.
/// [AdvStory] gives you all its power through [StoryContent].
class AdvancedCustomStoryContent extends StatelessWidget {
  /// Creates [AdvStory] view for advanced custom content example.
  const AdvancedCustomStoryContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvStory(
      storyCount: 5,
      storyBuilder: (storyIndex) {
        return Story(
          contentCount: 3,
          contentBuilder: (contentIndex) {
            return MyCustomContent(contentIndex: contentIndex);
          },
        );
      },
      trayBuilder: (storyIndex) {
        return Center(
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amberAccent.withOpacity(.85),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              "Advanced Content\n$storyIndex",
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

// Story logic must be controlled by developer in this type of content.
class MyCustomContent extends StoryContent {
  const MyCustomContent({
    required this.contentIndex,
    Key? key,
  }) : super(key: key);

  final int contentIndex;

  @override
  StoryContentState<MyCustomContent> createState() =>
      MyCustomStoryContentState();
}

/// #### WARNING:
/// > Any `AdvStory` method or variable provided by [StoryContent] class
/// **must** be used after `didChangeDependencies.super()` call. Recommendation
/// is to use `initContent` method.
/// >  If you absolutely must use `initState`, put your code in
/// `SchedulerBinding.instance.addPostFrameCallback()`.
///
/// You have direct access following methods/variables inside of state class:
///
/// - `controller` is [AdvStoryController]. Don't add listener to handle events,
/// see below for more information.
/// - `loadingScreen` is provided or default loading screen that used in
/// [AdvStory].
/// - `position` is the content and story position of this story content.
/// - `shouldShowLoading`
/// - `isFirstContent`
/// - `initContent` is called when `AdvStory` methods is ready to use.
/// See [StoryContent] for more information.
/// - `loadFile` method fetchs and caches a file from the internet.
/// When you use this method, your media will be cached in the device and when
/// your content is displayed again, it will load from the cache.
/// - `markReady` marks this content as ready to be displayed. You need to
/// call this method to notify [AdvStory] when your content is ready to
/// be displayed.
/// - `setTimeout` method sets a time limit to make this content ready. If
/// this content fails to call `markReady` within the given time, `onTimeout`
/// callback is executed.
///
/// ---
/// ---
/// [AdvStoryController] triggers all listeners on every event, but the methods
/// below will only fire on events related to this content.
/// **Use these methods to handle events related to this content.**
///
/// You need to override following methods to handle events related to this
/// content:
///
/// - `onStart()`
/// - `onPause()`
/// - `onResume()`
/// - `onStop()`
/// - `onTimeout()`
///
/// See [StoryContent] for more information.
class MyCustomStoryContentState extends StoryContentState<MyCustomContent> {
  File? _myImage;

  /// Do your async stuff and to notify [AdvStory] by calling [markReady]
  /// when content is ready to be displayed.
  Future<void> doMyAsyncStuff() async {
    /// Fetch and cache your file.
    final myImageFile = await loadFile(
      url: imageUrls[position.content % imageUrls.length],
    );

    setState(() {
      _myImage = myImageFile;
    });

    // Send story duration parameter to the markReady. AdvStory will use this
    // duration to start skip countdown.
    markReady(duration: const Duration(seconds: 15));
  }

  /// If you wonder why using initContent is better, see implementation of
  /// this method in [StoryContent].
  @override
  void initContent() {
    doMyAsyncStuff();
    // Set a time limit to load this content.
    setTimeout(const Duration(seconds: 10));
  }

  @override
  void onTimeout() {
    // Show a message to user if content couldn't be displayed in desired time.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Content couldn't be displayed in time."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // loadingScreen is your defined loading screen or AdvStory default one.
    // Check if this content should show a loading screen and return value
    // accordingly.
    if (_myImage == null) {
      return shouldShowLoading ? loadingScreen : const SizedBox();
    }

    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(_myImage!),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.deepOrange.withOpacity(.6),
              child: Text(
                "My story content for ${position.toString()}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
