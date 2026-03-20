import 'package:app/gen/assets.gen.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/bottom_bar/view/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> with AdaptivePage {
  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) {
    return mobileScreen(context);
  }

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) {
    return mobileScreen(context);
  }

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) {
    return tabletScreen(context);
  }

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) {
    return tabletScreen(context);
  }

  Widget mobileScreen(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundHomepage,
          actions: [notificationView()],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(color: AppColors.backgroundHomepage)),
                Expanded(
                    flex: 8,
                    child: Container(
                      width: double.infinity,
                      color: AppColors.primaryColor,
                    )),
              ],
            ),
            const BottomBar()
          ],
        ));
  }

  Widget tabletScreen(BuildContext context) {
    return Container();
  }

  Widget notificationView() {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: () {
          Get.toNamed("/notification");
        },
        child: Stack(
          children: [
            Container(
              height: 36.h,
              width: 36.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Assets.images.icNotification.svg(
                width: 24.w,
                height: 24.h,
              ),
            ),
            Positioned(
              right: 4.h,
              top: 2.h,
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 14.w,
                  minHeight: 14.h,
                ),
                child: Text(
                  "3",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
