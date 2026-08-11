import 'dart:ui';

import 'package:app/gen/assets.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/constant/constant.dart';
import 'package:app/domain/entities/bottom_bar/menubar_item.dart';
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
    return Positioned(
      left: 16.w,
      right: 16.w,
      bottom: 24.h,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              // ignore: deprecated_member_use
              color: AppColors.primarySecondaryColor.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 76.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(32.r),
                border: Border.all(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Obx(
                () {
                  final languageCode = _mainController.languageCode;
                  return Row(
                    key: ValueKey(languageCode),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _controller.menuUser
                        .map((item) => bottomBarItem(item))
                        .toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomBarItem(MenubarItem item) {
    return Obx(() {
      final isSelected = _controller.currentIndex.value == item.menuId;

      return GestureDetector(
        onTap: () {
          _controller.changeTap(item.menuId ?? 0);
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          width: 68.w,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.backgroundHomepage,
                      AppColors.primarySecondaryColor,
                    ],
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: isSelected
                    // ignore: deprecated_member_use
                    ? AppColors.primarySecondaryColor.withOpacity(0.35)
                    : Colors.transparent,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            scale: isSelected ? 1.2 : 1.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildIconMenu(menuId: item.menuId ?? 0, isSelected: isSelected),
                SizedBox(height: 3.h),
                Text(
                  buildLabelMenu(menuId: item.menuId ?? 0),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        // ignore: deprecated_member_use
                        : AppColors.lightTextColor.withOpacity(0.6),
                    fontSize: 10.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildIconMenu({required int menuId, required bool isSelected}) {
    final Color iconColor = isSelected
        ? Colors.white
        // ignore: deprecated_member_use
        : AppColors.lightTextColor.withOpacity(0.65);

    switch (menuId) {
      case StatusConstant.homeId:
        return Assets.images.icMenuHome.svg(
          width: 22.w,
          height: 22.h,
          // ignore: deprecated_member_use
          color: iconColor,
        );
      case StatusConstant.scheduleId:
        return Assets.images.icMenuCalendar.svg(
          width: 22.w,
          height: 22.h,
          // ignore: deprecated_member_use
          color: iconColor,
        );
      case StatusConstant.budgetId:
        return Assets.images.icMenuBudget.svg(
          width: 22.w,
          height: 22.h,
          // ignore: deprecated_member_use
          color: iconColor,
        );
      case StatusConstant.profileId:
        return Assets.images.icMenuProfile.svg(
          width: 22.w,
          height: 22.h,
          // ignore: deprecated_member_use
          color: iconColor,
        );
      default:
        return Assets.images.icMenuHome.svg(
          width: 22.w,
          height: 22.h,
          // ignore: deprecated_member_use
          color: iconColor,
        );
    }
  }

  buildLabelMenu({required int menuId}) {
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
