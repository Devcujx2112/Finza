import 'package:app/gen/assets.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/constant/status_constant.dart';
import 'package:app/domain/entities/bottom_bar/menubar_item.dart';
import 'package:app/src/feature/bottom_bar/bottom_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final BottomBarController _controller = BottomBarController();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20.w,
      right: 20.w,
      bottom: 20.h,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        decoration: BoxDecoration(
          color: AppColors.backgroundMenu,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: _controller.menuUser
              .map((item) => Expanded(child: bottomBarItem(item)))
              .toList(),
        ),
      ),
    );
  }

  Widget bottomBarItem(MenubarItem item) {
    return Obx(() {
      final isSelected = _controller.currentIndex.value == item.menuId;

      return GestureDetector(
        onTap: () {
          _controller.currentIndex.value = item.menuId ?? 0;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.only(
            top: 8.h,
            bottom: 8.h,
            left: isSelected ? 18.w : 15.w,
            right: isSelected ? 18.w : 15.w,
          ),
          decoration: BoxDecoration(
            color: isSelected
                // ignore: deprecated_member_use
                ? AppColors.darkBackgroundColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isSelected ? 1.1 : 1.0,
                child: buildIconMenu(menuId: item.menuId ?? 0),
              ),
              SizedBox(height: 4.h),
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  buildLabelMenu(menuId: item.menuId ?? 0),
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.darkBackgroundColor
                        : Colors.grey[600],
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildIconMenu({required int menuId}) {
    switch (menuId) {
      case StatusConstant.homeId:
        return Assets.images.icMenuHome.svg(
          width: 24.w,
          height: 24.h,
          color: _controller.currentIndex.value == menuId
              ? AppColors.colorMenuBar
              : Colors.grey[600],
        );
      case StatusConstant.scheduleId:
        return Assets.images.icMenuCalendar.svg(
          width: 24.w,
          height: 24.h,
          color: _controller.currentIndex.value == menuId
              ? AppColors.colorMenuBar
              : Colors.grey[600],
        );
      case StatusConstant.budgetId:
        return Assets.images.icMenuBudget.svg(
          width: 24.w,
          height: 24.h,
          color: _controller.currentIndex.value == menuId
              ? AppColors.colorMenuBar
              : Colors.grey[600],
        );
      case StatusConstant.profileId:
        return Assets.images.icMenuProfile.svg(
          width: 24.w,
          height: 24.h,
          color: _controller.currentIndex.value == menuId
              ? AppColors.colorMenuBar
              : Colors.grey[600],
        );
      default:
        return Assets.images.icMenuHome.svg(
          width: 24.w,
          height: 24.h,
          color: _controller.currentIndex.value == menuId
              ? AppColors.colorMenuBar
              : AppColors.lightGreyColor,
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
