import 'dart:ui';

import 'package:app/domain/entities/bottom_bar/menubar_item.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/constant/constant.dart';
import 'package:app/src/feature/bottom_bar/bottom_bar_controller.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final BottomBarController _controller = Get.find<BottomBarController>();
  final MainController _mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      left: 16.w,
      right: 16.w,
      bottom: 12.h,
      child: SafeArea(
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(
                  alpha: isDark ? 0.28 : 0.08,
                ),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.primarySecondaryColor.withValues(
                  alpha: isDark ? 0.08 : 0.04,
                ),
                blurRadius: 16,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                height: 66.h,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.homeDarkSurface.withValues(alpha: 0.85)
                      : AppColors.homeSurface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.whiteColor.withValues(alpha: 0.1)
                        : AppColors.blackColor.withValues(alpha: 0.06),
                    width: 1.w,
                  ),
                ),
                child: Obx(() {
                  final languageCode = _mainController.languageCode;
                  final menuItems = _controller.menuUser;
                  final currentIndex = _controller.currentIndex.value;

                  return LayoutBuilder(
                    key: ValueKey(languageCode),
                    builder: (context, constraints) {
                      final totalWidth = constraints.maxWidth;
                      final itemCount = menuItems.length;
                      if (itemCount == 0) return const SizedBox.shrink();

                      final itemWidth = totalWidth / itemCount;
                      final activeIndex = menuItems.indexWhere(
                        (e) => e.menuId == currentIndex,
                      );
                      final validActiveIndex = activeIndex >= 0
                          ? activeIndex
                          : 0;

                      // Alignment formula mapping index [0..itemCount-1] to [-1.0 .. 1.0]
                      final double alignmentX = itemCount > 1
                          ? -1.0 + (2.0 * validActiveIndex / (itemCount - 1))
                          : 0.0;

                      return Stack(
                        children: [
                          // Sliding active pill background indicator
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.fastOutSlowIn,
                            alignment: Alignment(alignmentX, 0),
                            child: Container(
                              width: itemWidth,
                              height: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.r),
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : AppColors.primarySecondaryColor
                                            .withValues(alpha: 0.12),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.35)
                                        : AppColors.primarySecondaryColor
                                              .withValues(alpha: 0.18),
                                    width: 1.w,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Tab Items Row
                          Row(
                            children: menuItems.map((item) {
                              final isSelected = currentIndex == item.menuId;
                              return Expanded(
                                child: _buildBottomBarItem(
                                  item: item,
                                  isSelected: isSelected,
                                  isDark: isDark,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarItem({
    required MenubarItem item,
    required bool isSelected,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        _controller.changeTap(item.menuId ?? 0);
      },
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              scale: isSelected ? 1.08 : 1.0,
              child: buildIconMenu(
                menuId: item.menuId ?? 0,
                isSelected: isSelected,
                isDark: isDark,
              ),
            ),
            SizedBox(height: 3.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                color: _getLabelColor(isSelected: isSelected, isDark: isDark),
                fontSize: 10.5.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.1,
              ),
              child: Text(
                buildLabelMenu(menuId: item.menuId ?? 0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLabelColor({required bool isSelected, required bool isDark}) {
    if (isSelected) {
      return isDark ? AppColors.whiteColor : AppColors.primarySecondaryColor;
    }

    return isDark
        ? AppColors.homeDarkMutedText.withValues(alpha: 0.75)
        : AppColors.homeMutedText;
  }

  Widget buildIconMenu({
    required int menuId,
    required bool isSelected,
    required bool isDark,
  }) {
    final Color iconColor = isSelected
        ? (isDark ? AppColors.whiteColor : AppColors.primarySecondaryColor)
        : (isDark
              ? AppColors.homeDarkMutedText.withValues(alpha: 0.75)
              : AppColors.homeMutedText);

    switch (menuId) {
      case StatusConstant.homeId:
        return Assets.images.icMenuHome.svg(
          width: 21.w,
          height: 21.h,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );

      case StatusConstant.scheduleId:
        return Assets.images.icMenuCalendar.svg(
          width: 21.w,
          height: 21.h,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );

      case StatusConstant.budgetId:
        return Assets.images.icMenuBudget.svg(
          width: 21.w,
          height: 21.h,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );

      case StatusConstant.profileId:
        return Assets.images.icMenuProfile.svg(
          width: 21.w,
          height: 21.h,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );

      default:
        return Assets.images.icMenuHome.svg(
          width: 21.w,
          height: 21.h,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        );
    }
  }

  String buildLabelMenu({required int menuId}) {
    final app = AppLocalizations.of(context);
    switch (menuId) {
      case StatusConstant.homeId:
        return app?.homePage ?? '';
      case StatusConstant.scheduleId:
        return app?.schedule ?? '';
      case StatusConstant.budgetId:
        return app?.budget ?? '';
      case StatusConstant.profileId:
        return app?.profile ?? '';
      default:
        return app?.homePage ?? '';
    }
  }
}
