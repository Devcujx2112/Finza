import 'package:app/src/core/color/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final bool showIndicator;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.showIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          AbsorbPointer(
            absorbing: true,
            child: Container(
              color: AppColors.blackColor.withValues(alpha: 0.3),
              child: showIndicator
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primarySecondaryColor,
                      ),
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}
