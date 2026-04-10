import 'package:app/gen/assets.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/onboarding/onboarding_controller.dart';
import 'package:app/src/feature/splash/splash_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> with AdaptivePage {
  final _controller = OnboardingController();
  final PageController pageController = PageController();
  final SplashPageController _splashPageController = SplashPageController();

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
    return mainOnboardingScreen(context);
  }

  Widget tabletScreen(BuildContext context) {
    return mainOnboardingScreen(context);
  }

  Widget mainOnboardingScreen(BuildContext context) {
    final app = AppLocalizations.of(context);

    return Container(
      color: AppColors.primarySecondaryColor,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Obx(
                  () => Text(
                    _controller.currentPage.value == 0
                        ? app?.introduction ?? ""
                        : app?.introductionSecond ?? "",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.lightTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 300.h,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index) {
                        _controller.currentPage.value = index;
                      },
                      children: [firstCurrentPage(), secondCurrentPage()],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20.h,
                    children: [
                      SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            if (_controller.currentPage.value == 1) {
                              Get.offAllNamed(RouterName.mainLogin);
                              _splashPageController.setOnboarding();
                            } else {
                              _controller.currentPage.value = 1;
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(
                              color: AppColors.primarySecondaryColor,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            app?.next ?? '',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primarySecondaryColor,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(2, (index) {
                            bool isActive =
                                _controller.currentPage.value == index;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: isActive ? 22.w : 10.w,
                              height: 10.h,
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isActive
                                    ? AppColors.primarySecondaryColor
                                    : AppColors.backgroundMenu,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget firstCurrentPage() {
    return SizedBox(
      width: 220.w,
      height: 220.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundMenu,
            ),
          ),
          Assets.images.imgOnboard.image(
            width: 260.w,
            height: 260.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget secondCurrentPage() {
    return SizedBox(
      width: 220.w,
      height: 220.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundMenu,
            ),
          ),
          Assets.images.imgOnboard2.image(
            width: 260.w,
            height: 260.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
