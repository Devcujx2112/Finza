import 'package:app/gen/assets.gen.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DraggableAiChatButton extends StatefulWidget {
  const DraggableAiChatButton({super.key});

  @override
  State<DraggableAiChatButton> createState() => _DraggableAiChatButtonState();
}

class _DraggableAiChatButtonState extends State<DraggableAiChatButton> {
  static const double _buttonSize = 48;
  static const double _screenMargin = 16;
  static const double _initialBottomOffset = 120;
  static const Duration _snapDuration = Duration(milliseconds: 220);

  final MainController _controller = Get.find<MainController>();
  Offset? _dragOffset;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_controller.shouldShowAiChatButton) {
        return const SizedBox.shrink();
      }

      return Positioned.fill(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final safePadding = MediaQuery.paddingOf(context);
            final bounds = _ButtonBounds(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              buttonSize: _buttonSize.r,
              margin: _screenMargin.r,
              safePadding: safePadding,
              initialBottomOffset: _initialBottomOffset.h,
            );
            final currentOffset = bounds.clamp(
              _dragOffset ?? _controller.aiChatButtonOffset ?? bounds.initial,
            );

            return Stack(
              children: [
                AnimatedPositioned(
                  duration: _isDragging ? Duration.zero : _snapDuration,
                  curve: Curves.easeOutCubic,
                  left: currentOffset.dx,
                  top: currentOffset.dy,
                  child: GestureDetector(
                    onPanStart: (_) {
                      setState(() {
                        _isDragging = true;
                        _dragOffset = currentOffset;
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _dragOffset = bounds.clamp(
                          (_dragOffset ?? currentOffset) + details.delta,
                        );
                      });
                    },
                    onPanEnd: (_) => _snapToNearestEdge(bounds, currentOffset),
                    onPanCancel: () =>
                        _snapToNearestEdge(bounds, currentOffset),
                    child: Container(
                      width: bounds.buttonSize,
                      height: bounds.buttonSize,
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 3,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Transform.scale(
                          scale: 1.1,
                          child: Assets.images.chatBoxAi.image(
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  void _snapToNearestEdge(_ButtonBounds bounds, Offset fallbackOffset) {
    final snappedOffset = bounds.snapToNearestEdge(
      _dragOffset ?? fallbackOffset,
    );
    _controller.setAiChatButtonOffset(snappedOffset);
    setState(() {
      _dragOffset = snappedOffset;
      _isDragging = false;
    });
  }
}

class _ButtonBounds {
  const _ButtonBounds({
    required this.width,
    required this.height,
    required this.buttonSize,
    required this.margin,
    required this.safePadding,
    required this.initialBottomOffset,
  });

  final double width;
  final double height;
  final double buttonSize;
  final double margin;
  final EdgeInsets safePadding;
  final double initialBottomOffset;

  double get minLeft => margin;
  double get minTop => safePadding.top + margin;

  double get maxLeft {
    final value = width - buttonSize - margin;
    return value < minLeft ? minLeft : value;
  }

  double get maxTop {
    final value = height - buttonSize - safePadding.bottom - margin;
    return value < minTop ? minTop : value;
  }

  Offset get initial =>
      clamp(Offset(maxLeft, height - buttonSize - initialBottomOffset));

  Offset clamp(Offset offset) {
    return Offset(
      offset.dx.clamp(minLeft, maxLeft).toDouble(),
      offset.dy.clamp(minTop, maxTop).toDouble(),
    );
  }

  Offset snapToNearestEdge(Offset offset) {
    final clamped = clamp(offset);
    var nearestDistance = (clamped.dx - minLeft).abs();
    var nearestOffset = Offset(minLeft, clamped.dy);

    void compareCandidate(double distance, Offset candidate) {
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestOffset = candidate;
      }
    }

    compareCandidate((clamped.dx - maxLeft).abs(), Offset(maxLeft, clamped.dy));
    compareCandidate((clamped.dy - minTop).abs(), Offset(clamped.dx, minTop));
    compareCandidate((clamped.dy - maxTop).abs(), Offset(clamped.dx, maxTop));

    return nearestOffset;
  }
}
