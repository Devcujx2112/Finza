import 'package:app/src/core/color/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  static Future<T?> showPicker<T>({
    required BuildContext context,
    required List<BottomNavigationPickerItem<T>> items,
    T? selectedValue,
    String? title,
    String? subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparentColor,
      barrierColor: AppColors.blackColor.withValues(alpha: 0.5),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.homeDarkSurface : AppColors.homeSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(
                  alpha: isDark ? 0.35 : 0.12,
                ),
                blurRadius: 28,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.whiteColor.withValues(alpha: 0.2)
                      : AppColors.blackColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              SizedBox(height: 18.h),

              // Title & Subtitle if present
              if (title != null || subtitle != null) ...[
                if (title != null)
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.whiteColor
                          : AppColors.lightTextColor,
                    ),
                  ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: isDark
                          ? AppColors.homeDarkMutedText
                          : AppColors.homeMutedText,
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
              ],

              // Items List
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = selectedValue != null
                        ? item.value == selectedValue
                        : false;

                    return Material(
                      color: AppColors.transparentColor,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(item.value),
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                    ? AppColors.primarySecondaryColor
                                        .withValues(alpha: 0.15)
                                    : AppColors.primarySecondaryColor
                                        .withValues(alpha: 0.08))
                                : (isDark
                                    ? AppColors.homeDarkSoftSurface
                                    : AppColors.homeSoftSurface),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primarySecondaryColor
                                  : AppColors.transparentColor,
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (item.symbol != null) ...[
                                Container(
                                  width: 32.r,
                                  height: 32.r,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primarySecondaryColor
                                        : (isDark
                                            ? AppColors.whiteColor
                                                .withValues(alpha: 0.1)
                                            : AppColors.blackColor
                                                .withValues(alpha: 0.06)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    item.symbol!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.whiteColor
                                          : (isDark
                                              ? AppColors.whiteColor
                                              : AppColors.lightTextColor),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: isDark
                                            ? AppColors.whiteColor
                                            : AppColors.lightTextColor,
                                      ),
                                    ),
                                    if (item.subtitle != null) ...[
                                      SizedBox(height: 2.h),
                                      Text(
                                        item.subtitle!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11.5.sp,
                                          color: isDark
                                              ? AppColors.homeDarkMutedText
                                              : AppColors.homeMutedText,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  CupertinoIcons.checkmark_alt,
                                  color: AppColors.primarySecondaryColor,
                                  size: 20.sp,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BottomNavigationPickerItem<T> {
  const BottomNavigationPickerItem({
    required this.value,
    required this.title,
    this.subtitle,
    this.symbol,
  });

  final T value;
  final String title;
  final String? subtitle;
  final String? symbol;
}

