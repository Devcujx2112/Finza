import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/bottom_bar/view/bottom_bar.dart';
import 'package:flutter/material.dart';

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
        body: Stack(
      children: [
        Column(
          children: [
            Expanded(flex: 3, child: Container(color: AppColors.darkTextColor)),
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
}
