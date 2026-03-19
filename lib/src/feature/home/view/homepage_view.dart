import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/bottom_bar/view/bottom_bar.dart';
import 'package:flutter/material.dart';
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
          title: Text("Home"),
          backgroundColor: AppColors.darkTextColor,
          actions: [notificationView()],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    flex: 3, child: Container(color: AppColors.darkTextColor)),
                Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      color: AppColors.primarySecondaryColor,
                    )),
              ],
            ),
            BottomBar()
          ],
        ));
  }

  Widget tabletScreen(BuildContext context) {
    return Container();
  }

  Widget notificationView() {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications_none),
          onPressed: () {
            Get.toNamed("/notification");
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              "3",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
