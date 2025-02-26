import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/user_steps/widget_utils.dart';

enum AutoMasking { labels, textInputs, media, none }

extension ValidationMethod on AutoMasking {
  bool Function(Widget) hides() {
    switch (this) {
      case AutoMasking.labels:
        return isTextWidget;
      case AutoMasking.textInputs:
        return isTextInputWidget;
      case AutoMasking.media:
        return isMedia;
      case AutoMasking.none:
        return (_) => false;
    }
  }
}

class ScreenshotPipeLine {
  ScreenshotPipeLine._internal();

  static final viewChecks = List.of([_isPrivate]);

  static void addAutoMasking(List<AutoMasking> masking) {
    viewChecks.addAll(masking.map((e) => e.hides()).toList());
  }

  static Future<Uint8List?> getScreenShot() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final context = instabugWidgetKey.currentContext;

    final renderObject = context?.findRenderObject() as RenderRepaintBoundary?;
    if (context == null || renderObject == null) {
      return null;
    }

    final image = renderObject.toImageSync();
    final rects = _getRectsOfPrivateViews();
    // Create a new canvas to draw on
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw the original image on the canvas
    final imagePaint = Paint();

    canvas.drawImage(image, Offset.zero, imagePaint);

    // Draw rectangles with black color
    final rectPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 1; // Adjust stroke width if needed

    for (final rect in rects) {
      canvas.drawRect(rect, rectPaint);
    }

    // Convert canvas to image
    final finalImage = recorder.endRecording().toImageSync(
          image.width,
          image.height,
        );

    final data = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    final imageBytes = data!.buffer.asUint8List();
    return imageBytes;
  }

  static List<Rect> _getRectsOfPrivateViews() {
    final context = instabugWidgetKey.currentContext;
    if (context == null) return [];

    final rootRenderObject =
        context.findRenderObject() as RenderRepaintBoundary?;
    if (rootRenderObject is! RenderBox) return [];

    final bounds = Offset.zero & rootRenderObject!.size;

    final rects = <Rect>[];

    void findPrivateViews(Element element) {
      final widget = element.widget;

      final isPrivate = viewChecks.any((e) => e.call(widget));
      // final isText = isTextWidget(widget);
      if (isPrivate) {
        final renderObject = element.findRenderObject();
        if (renderObject is RenderBox &&
            renderObject.attached &&
            element.mounted) {
          final isElementInCurrentScreen = _isElementInCurrentRoute(element);
          final rect = _getLayoutRectInfoFromRenderObject(renderObject);
          if (rect != null &&
              rect.overlaps(bounds) &&
              isElementInCurrentScreen) {
            rects.add(rect);
          }
        }
      } else {
        element.visitChildElements(findPrivateViews);
      }
    }

    rects.clear();
    context.visitChildElements(findPrivateViews);

    return rects;
  }

  static bool _isPrivate(Widget widget) {
    return widget.runtimeType.toString() == 'InstabugPrivateView' ||
        widget.runtimeType.toString() == 'InstabugSliverPrivateView';
  }

  static bool _isElementInCurrentRoute(Element element) {
    final modalRoute = ModalRoute.of(element);
    return modalRoute?.isCurrent ?? false;
  }

  static Rect? _getLayoutRectInfoFromRenderObject(RenderObject? renderObject) {
    if (renderObject == null) {
      return null;
    }

    final globalOffset = _getRenderGlobalOffset(renderObject);

    if (renderObject is RenderProxyBox) {
      if (renderObject.child == null) {
        return null;
      }

      return MatrixUtils.transformRect(
        renderObject.child!.getTransformTo(renderObject),
        Offset.zero & renderObject.child!.size,
      ).shift(globalOffset);
    }

    return renderObject.paintBounds.shift(globalOffset);
  }

  static Offset _getRenderGlobalOffset(RenderObject renderObject) {
    return MatrixUtils.transformPoint(
      renderObject.getTransformTo(null),
      Offset.zero,
    );
  }
}
