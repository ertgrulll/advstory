## 0.0.1

- 🎉 first release!

## 0.0.1+1

- Readme image source change

## 0.0.1+2

- Readme change, again...

## 0.1.0

***This version has breaking changes.***
- All `*story` has been renamed `*content` and all `*cluster` has been renamed `*story`:
    - `Cluster` as `Story`
    - `clusterBuilder` as `storyBuilder`
    - `clusterCount` as `storyCount`
    - `storyBuilder` as `contentBuilder`
    - `ImageStory` as `ImageContent`
    - `VideoStory` as `VideoContent`
    - And related controller methods...
- `TrayStyle` has been renamed as `TrayListStyle`
- `hideBars` parameter moved to `AdvStoryStyle` from `AdvStory` widget.
- Removed `storyIndex` and `clusterIndex` from `AdvStoryController` and added `position`.
- A brand new logic has been created to give more flexibility to custom story contents.
- Removed `WidgetStory` and implemented 2 new way to create custom story contents:
    - `StoryContent` is an abstract class that gives the full power of `AdvStory` to the developer. `StoryContent` is super class of built-in types, this means you can use any required method by extending this class.
    - `SimpleCustomContent` is a custom story content using resources that can be loaded simultaneously. Eg text, asset image...
- Added `timeout` and `errorBuilder` parameters to video content and image content.
- Added a parameter to set duration for each story except `VideoContent`. You can now set duration for every single story content!
- Removed `setVolume` method from `AdvStoryController`. You can now extend `StoryContent` to create customized controls.
- Added two new parameters to `AdvStory` widget to disable preloading.
- Default loading screen has changed. Shimmer effect was causing a lag.
- Fixed a bug that caused the story to not start when the first content was custom content.
- Improved documentation and example project.
