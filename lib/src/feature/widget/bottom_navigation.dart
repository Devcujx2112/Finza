import 'package:app/src/core/color/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  static Future<T?> showPicker<T>({
    required BuildContext context,
    required List<BottomNavigationPickerItem<T>> items,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (context) {
        final textColor = Theme.of(context).brightness == Brightness.dark
            ? AppColors.whiteColor
            : AppColors.blackColor;

        return CupertinoActionSheet(
          actions: items
              .map(
                (item) => CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(context).pop(item.value),
                  child: Text(item.title, style: TextStyle(color: textColor)),
                ),
              )
              .toList(),
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
  const BottomNavigationPickerItem({required this.value, required this.title});

  final T value;
  final String title;
}
