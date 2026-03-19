import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  BottomBar({super.key, this.currentIndex});

  int? currentIndex = 0;
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  color: widget.currentIndex == 0 ? Colors.blue : Colors.grey,
                ),
                SizedBox(width: 40.w),
                Icon(
                  Icons.search,
                  color: widget.currentIndex == 1 ? Colors.blue : Colors.grey,
                ),
                SizedBox(width: 40.w),
                Icon(
                  Icons.person,
                  color: widget.currentIndex == 2 ? Colors.blue : Colors.grey,
                ),
              ],
            )));
  }
}
