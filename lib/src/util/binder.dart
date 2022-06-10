import 'dart:async';

import 'package:flutter/foundation.dart';

/// Takes a [value] and a [binding] callback to bridging between and creates a
/// listenable.
///
/// When the value changed, invokes [binding] with the new value.
class Binded<T> extends ChangeNotifier implements ValueListenable<T> {
  /// Creates a [Binded] instance.
  Binded(this._value, this.binding) {
    binding(_value);
  }

  /// Value of the listenable.
  T _value;

  /// Callback to be invoked when the value changes.
  FutureOr<void> Function(T) binding;

  @override
  T get value => _value;

  /// If the value is changed, sets the value of the listenable.
  ///
  /// Invokes [binding] with the new value and notifies listeners about the
  /// change.
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      binding(_value);

      notifyListeners();
    }
  }

  /// Executes [binding] with the current value of the listenable.
  void update() => binding(_value);
}

/// Shortcut for creating [Binded] instance.
extension Binder<T> on T {
  /// Creates a new [Binded], bridges a variable to a function. Invokes
  /// [binding] with the initial value on bind.
  Binded<T> bind(FutureOr<void> Function(T) binding) {
    return Binded<T>(this, binding);
  }
}
