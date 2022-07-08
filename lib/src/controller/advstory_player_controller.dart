import 'package:advstory/src/advstory.dart';
import 'package:advstory/src/controller/advstory_controller.dart';
import 'package:advstory/src/controller/advstory_player_controller_impl.dart';
import 'package:advstory/src/model/story_position.dart';

/// Controller to manage [AdvStory.player] widget.
///
/// Includes all [AdvStoryController] methods and also has player specific
/// methods over [AdvStoryController].
abstract class AdvStoryPlayerController implements AdvStoryController {
  factory AdvStoryPlayerController() = AdvStoryPlayerControllerImpl;

  /// Opens story view at the given position.
  Future<void> open(StoryPosition position);

  /// Closes story view.
  ///
  /// `Navigator.pop` can't be used to close story view like on [AdvStory]
  /// widget, when story widget created using [AdvStory.player], call this
  /// method instead.
  void close();

  /// Returns true if story view is on screen, false otherwise.
  bool get isShowing;
}
