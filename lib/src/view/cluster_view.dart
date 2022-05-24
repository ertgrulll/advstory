import 'package:advstory/advstory.dart';
import 'package:advstory/src/view/components/async_page_view.dart';
import 'package:advstory/src/view/data_provider.dart';
import 'package:advstory/src/view/story_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Creates a story group view.
class ClusterView extends StatefulWidget {
  /// Widget that displays the [Cluster]'s, using [PageView].
  const ClusterView({Key? key}) : super(key: key);

  @override
  ClusterViewState createState() => ClusterViewState();
}

/// State for [ClusterView].
class ClusterViewState extends State<ClusterView>
    with TickerProviderStateMixin {
  late DataProvider _provider;

  @override
  void didChangeDependencies() {
    _provider = DataProvider.of(context)!;
    if (_provider.hideBars) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (_provider.hideBars) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }

    _provider.controller.notifyListeners(StoryEvent.close);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder(
        valueListenable: _provider.controller.gesturesDisabled,
        builder: (context, bool value, child) {
          return IgnorePointer(
            ignoring: value,
            child: child,
          );
        },
        child: AsyncPageView(
          // Added one more page to detect when user swiped past the last page
          itemCount: _provider.controller.clusterCount + 1,
          controller: _provider.controller.clusterController,
          loadingScreen: _provider.style(),
          itemBuilder: (context, index) async {
            // If user swipes past the last page, return a blank view before
            //  closing cluster view.
            if (index == _provider.controller.clusterCount) {
              return const SizedBox();
            }
            final cluster = await _provider.buildHelper.buildCluster(index);

            return StoryView(
              clusterIndex: index,
              cluster: cluster,
            );
          },
          onPageChanged: (index) {
            // User reached to the last page, close cluster view.
            if (index == _provider.controller.clusterCount) {
              Navigator.of(context).pop();
            } else {
              _provider.controller.handleClusterChange(index);
            }
          },
        ),
      ),
    );
  }
}
