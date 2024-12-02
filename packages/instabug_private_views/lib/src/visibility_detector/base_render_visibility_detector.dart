import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:instabug_private_views/src/visibility_detector/visibillity_utils.dart';

typedef VisibilityChangedCallback = void Function(bool isVisible);

mixin RenderVisibilityDetectorBase on RenderObject {
  static int? get debugUpdateCount {
    if (!kDebugMode) {
      return null;
    }
    return _updates.length;
  }

  static Duration updateInterval = const Duration(milliseconds: 500);
  static final Map<Key, VoidCallback> _updates = <Key, VoidCallback>{};
  static final Map<Key, bool> _lastVisibility = <Key, bool>{};

  static void forget(Key key) {
    _updates.remove(key);
    _lastVisibility.remove(key);

    if (_updates.isEmpty) {
      _timer?.cancel();
      _timer = null;
    }
  }

  static Timer? _timer;

  static void _handleTimer() {
    _timer = null;
    // Ensure that work is done between frames so that calculations are
    // performed from a consistent state.  We use `scheduleTask<T>` here instead
    // of `addPostFrameCallback` or `scheduleFrameCallback` so that work will
    // be done even if a new frame isn't scheduled and without unnecessarily
    // scheduling a new frame.
    SchedulerBinding.instance.scheduleTask<void>(
      _processCallbacks,
      Priority.touch,
    );
  }

  /// Executes visibility callbacks for all updated instances.
  static void _processCallbacks() {
    for (final callback in _updates.values) {
      callback();
    }

    _updates.clear();
  }

  void _fireCallback(ContainerLayer? layer, Rect bounds) {
    final oldInfo = _lastVisibility[key];
    final visible = _determineVisibility(layer, bounds);

    if (visible == oldInfo) {
      return;
    }

    if (visible) {
      _lastVisibility[key] = visible;
    } else {
      // Track only visible items so that the map does not grow unbounded.
      if (oldInfo != null) {
      _lastVisibility.remove(key);
    }
    }

    onVisibilityChanged?.call(visible);
  }

  /// The key for the corresponding [VisibilityDetector] widget.
  Key get key;

  VoidCallback? _compositionCallbackCanceller;

  VisibilityChangedCallback? _onVisibilityChanged;

  // ignore: use_setters_to_change_properties
  void init({required VisibilityChangedCallback? visibilityChangedCallback}) {
    _onVisibilityChanged = visibilityChangedCallback;
  }

  VisibilityChangedCallback? get onVisibilityChanged => _onVisibilityChanged;

  set onVisibilityChanged(VisibilityChangedCallback? value) {
    _compositionCallbackCanceller?.call();
    _compositionCallbackCanceller = null;
    _onVisibilityChanged = value;

    if (value == null) {
      forget(key);
    } else {
      markNeedsPaint();
      // If an update is happening and some ancestor no longer paints this RO,
      // the markNeedsPaint above will never cause the composition callback to
      // fire and we could miss a hide event. This schedule will get
      // over-written by subsequent updates in paint, if paint is called.
      _scheduleUpdate();
    }
  }

  int _debugScheduleUpdateCount = 0;

  /// The number of times the schedule update callback has been invoked from
  /// [Layer.addCompositionCallback].
  ///
  /// This is used for testing, and always returns null outside of debug mode.
  @visibleForTesting
  int? get debugScheduleUpdateCount {
    if (kDebugMode) {
      return _debugScheduleUpdateCount;
    }
    return null;
  }

  void _scheduleUpdate([ContainerLayer? layer]) {
    if (kDebugMode) {
      _debugScheduleUpdateCount += 1;
    }
    final isFirstUpdate = _updates.isEmpty;
    _updates[key] = () {
      if (bounds == null) {
        return;
      }
      _fireCallback(layer, bounds!);
    };

    if (updateInterval == Duration.zero) {
      if (isFirstUpdate) {
        // We're about to render a frame, so a post-frame callback is guaranteed
        // to fire and will give us the better immediacy than `scheduleTask<T>`.
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          _processCallbacks();
        });
      }
    } else if (_timer == null) {
      // We use a normal [Timer] instead of a [RestartableTimer] so that changes
      // to the update duration will be picked up automatically.
      _timer = Timer(updateInterval, _handleTimer);
    } else {
      assert(_timer!.isActive);
    }
  }

  bool _determineVisibility(ContainerLayer? layer, Rect bounds) {
    if (_disposed || layer == null || layer.attached == false || !attached) {
      // layer is detached and thus invisible.
      return false;
    }
    final transform = Matrix4.identity();

    // Check if any ancestors decided to skip painting this RenderObject.
    if (parent != null) {
      // ignore: unnecessary_cast
      var ancestor = parent! as RenderObject;
      RenderObject child = this;
      while (ancestor.parent != null) {
        if (!ancestor.paintsChild(child)) {
          return false;
        }
        child = ancestor;
        // ignore: unnecessary_cast
        ancestor = ancestor.parent! as RenderObject;
      }
    }

    // Create a list of Layers from layer to the root, excluding the root
    // since that has the DPR transform and we want to work with logical pixels.
    // Add one extra leaf layer so that we can apply the transform of `layer`
    // to the matrix.
    ContainerLayer? ancestor = layer;
    final ancestors = <ContainerLayer>[ContainerLayer()];
    while (ancestor != null && ancestor.parent != null) {
      ancestors.add(ancestor);
      ancestor = ancestor.parent;
    }

    var clip = Rect.largest;
    for (var index = ancestors.length - 1; index > 0; index -= 1) {
      final parent = ancestors[index];
      final child = ancestors[index - 1];
      final parentClip = parent.describeClipBounds();
      if (parentClip != null) {
        clip = clip.intersect(MatrixUtils.transformRect(transform, parentClip));
      }
      parent.applyTransform(child, transform);
    }

    // Apply whatever transform/clip was on the canvas when painting.
    if (_lastPaintClipBounds != null) {
      clip = clip.intersect(
        MatrixUtils.transformRect(
          transform,
          _lastPaintClipBounds!,
        ),
      );
    }
    if (_lastPaintTransform != null) {
      transform.multiply(_lastPaintTransform!);
    }
    return isWidgetVisible(
      MatrixUtils.transformRect(transform, bounds),
      clip,
    );
  }

  /// Used to get the bounds of the render object when it is time to update
  /// clients about visibility.
  ///
  /// A null value means bounds are not available.
  Rect? get bounds;

  Matrix4? _lastPaintTransform;
  Rect? _lastPaintClipBounds;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (onVisibilityChanged != null) {
      _lastPaintClipBounds = context.canvas.getLocalClipBounds();
      _lastPaintTransform =
          Matrix4.fromFloat64List(context.canvas.getTransform())
            ..translate(offset.dx, offset.dy);

      _compositionCallbackCanceller?.call();
      _compositionCallbackCanceller =
          context.addCompositionCallback((Layer layer) {
        assert(!debugDisposed!);
        final container = layer is ContainerLayer ? layer : layer.parent;
        _scheduleUpdate(container);
      });
    }
    super.paint(context, offset);
  }

  bool _disposed = false;

  @override
  void dispose() {
    _compositionCallbackCanceller?.call();
    _compositionCallbackCanceller = null;
    _disposed = true;
    super.dispose();
  }
}

class RenderVisibilityDetector extends RenderProxyBox
    with RenderVisibilityDetectorBase {
  RenderVisibilityDetector({
    RenderBox? child,
    required this.key,
    required VisibilityChangedCallback? onVisibilityChanged,
  }) : super(child) {
    _onVisibilityChanged = onVisibilityChanged;
  }

  @override
  final Key key;

  @override
  Rect? get bounds => hasSize ? semanticBounds : null;
}
