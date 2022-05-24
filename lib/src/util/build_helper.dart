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
  BuildHelper({this.clusterBuilder}) {
    _clusterBuildStack = <int>[].bind(_builderStackHandler);
  }

  ClusterBuilder? clusterBuilder;

  final clusters = <int, Cluster>{};

  late final Binded<List<int>> _clusterBuildStack;
  bool _hasPriorItem = false;

  /// Pauses cluster builds that has not priority, builds and returns required
  /// cluster first.
  Future<Cluster> buildCluster(int index) async {
    if (!clusters.containsKey(index)) {
      _hasPriorItem = true;
      await _buildCluster(index);

      _hasPriorItem = false;
    }

    _clusterBuildStack.update();

    return clusters[index]!;
  }

  /// Builds cluster and caches it to memory to make it ready to display.
  void prepareCluster(int index) {
    if (clusters.containsKey(index)) return;

    _clusterBuildStack.value = [..._clusterBuildStack.value, index];
  }

  Future<void> _builderStackHandler(List<int> indexes) async {
    for (int i = 0; i < indexes.length; i++) {
      if (_hasPriorItem) {
        return;
      }

      final index = indexes.first;
      _clusterBuildStack.value.removeAt(0);

      await _buildCluster(index);
    }
  }

  Future<void> _buildCluster(int index) async {
    final cluster = await clusterBuilder!.call(index);
    clusters[index] = cluster;
  }

  /// Fetches media file from the internet and caches it to local storage.
  Future<File> getMediaFile({
    required String url,
    Map<String, String>? headers,
    String? key,
  }) async {
    return DefaultCacheManager().getSingleFile(
      url,
      key: key ?? url,
      headers: headers,
    );
  }
}
