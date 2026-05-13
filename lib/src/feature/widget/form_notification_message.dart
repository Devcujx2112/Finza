import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum FormMessageType { success, warning, error }

class FormNotificationMessage extends StatefulWidget {
  final FormMessageType type;
  final String title;

  const FormNotificationMessage({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  State<FormNotificationMessage> createState() =>
      _FormNotificationMessageState();
}

class _FormNotificationMessageState extends State<FormNotificationMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();

    // Tự động đóng sau 1.5s
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _color {
    switch (widget.type) {
      case FormMessageType.success:
        return const Color(0xFF10B981);
      case FormMessageType.warning:
        return const Color(0xFFF59E0B);
      case FormMessageType.error:
        return const Color(0xFFEF4444);
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case FormMessageType.success:
        return Icons.check_circle_outline_rounded;
      case FormMessageType.warning:
        return Icons.warning_amber_rounded;
      case FormMessageType.error:
        return Icons.error_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: _color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_icon, color: _color, size: 56.sp),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: _color,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showFormMessageDialog(
  BuildContext context, {
  required FormMessageType type,
  required String title,
  bool barrierDismissible = false,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return FormNotificationMessage(type: type, title: title);
    },
  );
}
