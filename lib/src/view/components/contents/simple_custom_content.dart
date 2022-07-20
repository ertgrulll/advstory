import 'package:advstory/src/advstory.dart';
import 'package:advstory/src/view/components/contents/contents_base.dart';
import 'package:advstory/src/view/inherited_widgets/data_provider.dart';
import 'package:advstory/src/contants/enums.dart';
import 'package:advstory/src/view/inherited_widgets/content_position_provider.dart';
import 'package:flutter/material.dart';

/// Type for contents using sources that can be loaded synchronously.
/// For example [Text], [AssetImage]...
///
/// When you need more control, create your own content by extending
/// [StoryContent] and use [AdvStory] functionality.
class SimpleCustomContent extends StatefulWidget implements AdvStoryContent {
  /// Creates view for synchronous contents. If you are using network images,
  /// videos etc. inside your content, you shouldn't use [SimpleCustomContent].
  const SimpleCustomContent({
    required this.builder,
    this.useStoryHeader = false,
    this.useStoryFooter = false,
    this.duration = const Duration(seconds: 10),
    Key? key,
  }) : super(key: key);

  /// Content builder function.
  final Widget Function(BuildContext) builder;

  /// Skip duration of the content.
  final Duration duration;

  /// Sets whether the content should use the default story header.
  final bool useStoryHeader;

  /// Sets whether the content should use the default story footer.
  final bool useStoryFooter;

  @override
  State<SimpleCustomContent> createState() => _SimpleCustomContentState();
}

/// State class for [SimpleCustomContent].
class _SimpleCustomContentState extends State<SimpleCustomContent> {
  DataProvider? _dataProvider;
  ContentPositionProvider? _positionProvider;
  StoryStatus _status = StoryStatus.stop;

  Future<void> _starter() async {
    final currentPos = _dataProvider!.positionNotifier;
    final position = _positionProvider!.position;

    if (currentPos == position && !_status.shouldPlay) {
      _dataProvider!.controller.flowManager.start(position, widget.duration);
      _status = currentPos.status;
    } else if (currentPos != position && !_status.shouldStop) {
      _status = StoryStatus.stop;
    }
  }

  @override
  void didChangeDependencies() {
    if (_dataProvider == null) {
      _dataProvider = DataProvider.of(context)!;
      _positionProvider = ContentPositionProvider.of(context)!;

      _dataProvider!.positionNotifier
          .addListener(_starter, position: _positionProvider!.position);
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dataProvider!.positionNotifier.removeListener(_starter);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
