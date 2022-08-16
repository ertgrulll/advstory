<img src="https://files.gitbook.com/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FLZoq1vLHUTwBd2vqtB84%2Fuploads%2FanFNgKBQRGFKJQ7HK2It%2Fanimated_tray_cover.gif?alt=media&token=7e42ec27-fcec-48d5-8d97-6250d60b5b23">

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/ertgrulll) [![pub package](https://img.shields.io/pub/v/advstory.svg)](https://pub.dev/packages/advstory) [![GitHub issues-closed](https://img.shields.io/github/issues-closed/ertgrulll/advstory)](https://github.com/ertgrulll/advstory/issues)

## AdvStory 📸

#### _Quite simple & Quite advanced_

___

🚀 Advanced Story viewer for Flutter. Create and customize slideshow presentations similar to Instagram, TikTok and Snapchat stories. Supports image, video and custom story contents. Full control over stories for developer and smooth experience for users.

## _Features_

➡️ High performance, minimum delays, preload and cache enabled. Works using builders, provides flexibility and lazy loading.

➡️ Story view can be in any shape, size and position or full-screen.

➡️ Predefined story types for images, videos and simple contents. But not limited to these types, allows you to use base class of predefined widgets.    This literally makes the options endless.

➡️ Gestures for skip story, skip content, pause, resume and close.

➡️ Interceptors that block events and manipulate the story flow without being noticed by the app user.

➡️ A functional controller for listening interactions and skip stories/contents, pause, play and more...

➡️ Predefined highly customizable story tray. But you are not limited to that, you can create your own non-animated or animated trays, _`AdvStory`_ handles animation.

➡️ Header and footer areas for predefined stories with customization option specific to a predefined story content.

➡️ Object based, you can create as many story views as you want within the same application.

➡️ Well documented, go to docs:

* [![docs](https://img.shields.io/badge/AdvStory-Documentation-9cflogo=gitbook?color=7395de)](https://advstory.sourcekod.com)

___

## _What can I do using AdvStory?_

- _Quite simple:_ when you don't need much customization, a fully functional story view is just **8 lines of code**.

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
- _Quite advanced:_ when you need more you can,
    - create stories asynchronously in `storyBuilder`, send some requests to your server!
    - create different story trays and tray animations for each story, trays can be any widget you want.
    - create different footer & header areas for each story contents.
    - create contents with different skip durations.
    - create your own contents, `AdvStory` provides ways to you for caching media and handling story logic.
    - disable gestures, jump to a position, hide and show header/footer areas, pause and resume story via controller.
    - block events and call your own callbacks instead default story flow actions via interceptor.
    - create story view using `AdvStory.player` to define opening animations, custom shape, size...
    - customize tray list, story progress indicator, loading screen.

> If you find `AdvStory` useful, you can hit the like button and give a star to project on [Github](https://github.com/ertgrulll/advstory) to motivate me or treat me with [coffee](https://www.buymeacoffee.com/ertgrulll) to help me take time to develop this package.

___

### 🤝🏼 _Supporters & Sponsors_

- [jtkeyva](https://github.com/jtkeyva) ☕️ x 5

___

### Roadmap

| Status | Goal | 
| :---: | :--- | 
| 🚀 | Custom advanced contents
| ❌ | [Custom gestures](https://github.com/ertgrulll/advstory/issues/4)
| 🚀 | Decouple trays & player
| ❌ | [Web & Windows & MacOs & Linux support](https://github.com/ertgrulll/advstory/issues/6)

___

#### _Some screenshots:_

<p align="left">
    <img src="https://github.com/ertgrulll/advstory/blob/master/github_images/story_view_demo.gif?raw=true" height="400" hspace="1%"/>
    <img src="https://github.com/ertgrulll/advstory/blob/master/github_images/adv_story_tray_customizations.gif?raw=true" height="400" hspace="1%">
</p>

