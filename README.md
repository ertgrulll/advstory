<img src="https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FLZoq1vLHUTwBd2vqtB84%2Fuploads%2FanFNgKBQRGFKJQ7HK2It%2Fanimated_tray_cover.gif?alt=media&token=7e42ec27-fcec-48d5-8d97-6250d60b5b23">

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/ertgrulll) [![pub package](https://img.shields.io/pub/v/advstory.svg)](https://pub.dev/packages/advstory) [![GitHub issues-closed](https://img.shields.io/github/issues-closed/ertgrulll/advstory)](https://github.com/ertgrulll/advstory/issues) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://gitHub.com/ertgrulll/advstory/graphs/commit-activity) [![wakatime](https://wakatime.com/badge/user/9d195fb9-343f-40d6-9803-21db49aef0ba/project/b73ef7a8-4526-4918-aeec-a7bff0367592.svg)](https://wakatime.com/@ertgrull/projects/rojtggywss)

## AdvStory 📸

#### _Quite simple & Quite advanced_

___

🚀 Advanced Story viewer for Flutter. Supports image, video and custom stories. Full control over stories for developer and smooth experience for users.

## _Features_

➡️ High performance, minimum delays, preload and cache enabled. Works using builders,
   provides flexibility and lazy loading.

➡️ Gestures for skip story, skip content, pause, resume and close.

➡️ A functional controller for manipulating story flow and listening for user interactions.
   Allows you to skip, pause, play and more...

➡️ Predefined story types for images, videos and simple contents. But not limited to these types, allows you to use base class of predefined widgets.    This literally makes the options endless.

➡️ Different durations can be set for each story content.

➡️ Predefined highly customizable story tray. But you are not limited to that, you can create your own non-animated or animated trays, _`AdvStory`_ handles animation.

➡️ Header and footer areas for stories with customization option specific to a predefined story content.

➡️ Full screen option, hides status and navigation bars.

➡️ Object based, you can create as many story views as you want within the same application.

➡️ Well documented, go to docs:

* [![docs](https://img.shields.io/badge/AdvStory-Documentation-9cflogo=gitbook?color=7395de)](https://advstory.sourcekod.com)

___

## _What can I do using AdvStory?_

- _Quite simple_: when you don't need much customization, a fully functional story view is just **8 lines of code**.

```dart
AdvStory(
  storyCount: 5,
  storyBuilder: (storyIndex) => Story(
    contentCount: 10,
    contentBuilder: (contentIndex) => const ImageContent(url: ""),
  ),
  trayBuilder: (index) => AdvStoryTray(url: ""),
);
```
- _Quite advanced_: when you need more, you can:
    - create your stories asynchronously in storyBuilder, send some requests to your server!
    - create different story trays for each story, trays can be any widget you want.
    - create custom story tray animations for each story.
    - create different footer & header areas for each story contents.
    - create contents with different skip durations.
    - create your own contents, `AdvStory` provides ways to you for caching media and handling story logic.
    - control flow using `AdvStoryController`.
    - customize tray list, story progress indicator, loading screen, shimmer effect.

> If you find `AdvStory` useful, you can hit the like button and give a star to project on [Github](https://github.com/ertgrulll/advstory) to motivate me or treat me with [coffee](https://www.buymeacoffee.com/ertgrulll) to help me take time to develop this package.

___

### 🤝🏼 _Supporters & Sponsors_

- `null` 😐

___

### Roadmap

| Status | Goal | 
| :---: | :--- | 
| 🚀 | Custom advanced contents | `done`
| ❌ | [Custom gestures](https://github.com/ertgrulll/advstory/issues/4)
| ❌ | [Decouple trays & player](https://github.com/ertgrulll/advstory/issues/4) 
| ❌ | [Web & Windows & MacOs & Linux support](https://github.com/ertgrulll/advstory/issues/6)

___

#### _Some screenshots:_

<p align="left">
    <img src="https://github.com/ertgrulll/advstory/blob/master/github_images/story_view_demo.gif?raw=true" height="400" hspace="1%"/>
    <img src="https://github.com/ertgrulll/advstory/blob/master/github_images/adv_story_tray_customizations.gif?raw=true" height="400" hspace="1%">
</p>

