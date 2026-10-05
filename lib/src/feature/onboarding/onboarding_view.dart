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
import 'package:google_fonts/google_fonts.dart';

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
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onCompleteOnboarding() {
    _splashPageController.setOnboarding();
    Get.offAllNamed(RouterName.mainLogin);
  }

  void _onNextPage() {
    if (_controller.currentPage.value == 1) {
      _onCompleteOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) {
    return _buildResponsiveLayout(context, size, isLandscape: true);
  }

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) {
    return _buildResponsiveLayout(context, size, isLandscape: false);
  }

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) {
    return _buildResponsiveLayout(context, size, isLandscape: true);
  }

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) {
    return _buildResponsiveLayout(context, size, isLandscape: false);
  }

  Widget _buildResponsiveLayout(
    BuildContext context,
    Size size, {
    required bool isLandscape,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.homeDarkBackground
        : AppColors.homeLightBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: isLandscape
            ? _buildLandscapeContent(context, isDark)
            : _buildPortraitContent(context, isDark),
      ),
    );
  }

  Widget _buildPortraitContent(BuildContext context, bool isDark) {
    final app = AppLocalizations.of(context);

    final pages = [
      _OnboardingPageData(
        title: app?.introduction ?? 'Welcome to Expense Manager Finza',
        description:
            app?.introductionSecond ??
            'One place to manage your time and finances',
        imageWidget: Assets.images.imgOnboard.image(
          width: 240.w,
          height: 240.h,
          fit: BoxFit.contain,
        ),
        tagline: app?.finzaAppTagline ?? 'FINZA APP',
      ),
      _OnboardingPageData(
        title:
            app?.createAccountIntroduction ??
            'Join Finza today and start managing your finances better.',
        description:
            app?.textSignature ?? 'Balance your time. Balance your life.',
        imageWidget: Assets.images.imgOnboard2.image(
          width: 240.w,
          height: 240.h,
          fit: BoxFit.contain,
        ),
        tagline: app?.smartManagementTagline ?? 'SMART MANAGEMENT',
      ),
    ];

    return Column(
      children: [
        // Top Bar (Skip Button)
        _buildTopBar(context, isDark),

        // PageView Content
        Expanded(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              _controller.currentPage.value = index;
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return _buildPageItem(pages[index], isDark);
            },
          ),
        ),

        // Bottom Navigation Bar & Indicator
        _buildBottomControls(context, isDark, pages.length),
      ],
    );
  }

  Widget _buildLandscapeContent(BuildContext context, bool isDark) {
    final app = AppLocalizations.of(context);

    final pages = [
      _OnboardingPageData(
        title: app?.introduction ?? 'Welcome to Expense Manager Finza',
        description:
            app?.introductionSecond ??
            'One place to manage your time and finances',
        imageWidget: Assets.images.imgOnboard.image(
          width: 180.w,
          height: 180.h,
          fit: BoxFit.contain,
        ),
        tagline: app?.finzaAppTagline ?? 'FINZA APP',
      ),
      _OnboardingPageData(
        title:
            app?.createAccountIntroduction ??
            'Join Finza today and start managing your finances better.',
        description:
            app?.textSignature ?? 'Balance your time. Balance your life.',
        imageWidget: Assets.images.imgOnboard2.image(
          width: 180.w,
          height: 180.h,
          fit: BoxFit.contain,
        ),
        tagline: app?.smartManagementTagline ?? 'SMART MANAGEMENT',
      ),
    ];

    return Column(
      children: [
        _buildTopBar(context, isDark),
        Expanded(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              _controller.currentPage.value = index;
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final page = pages[index];
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                child: Row(
                  children: [
                    Expanded(child: _buildImageContainer(page.imageWidget, isDark)),
                    SizedBox(width: 32.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTagline(page.tagline, isDark),
                          SizedBox(height: 8.h),
                          Text(
                            page.title,
                            style: GoogleFonts.poppins(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.whiteColor
                                  : AppColors.lightTextColor,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            page.description,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.homeDarkMutedText
                                  : AppColors.homeMutedText,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildBottomControls(context, isDark, pages.length),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    final app = AppLocalizations.of(context);
    final skipText = app?.skip ?? 'Skip';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo Mark
          Row(
            children: [
              Assets.images.logoApp.svg(
                width: 28.w,
                height: 28.h,
              ),
              SizedBox(width: 8.w),
              Text(
                'Finza',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.whiteColor
                      : AppColors.lightTextColor,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          // Skip Button
          Obx(
            () => AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _controller.currentPage.value == 1 ? 0.0 : 1.0,
              child: IgnorePointer(
                ignoring: _controller.currentPage.value == 1,
                child: TextButton(
                  onPressed: _onCompleteOnboarding,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    skipText,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.homeDarkMutedText
                          : AppColors.homeMutedText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageItem(_OnboardingPageData page, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 12.h),
                _buildImageContainer(page.imageWidget, isDark),
                SizedBox(height: 32.h),
                _buildTagline(page.tagline, isDark),
                SizedBox(height: 10.h),
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.whiteColor
                        : AppColors.lightTextColor,
                    height: 1.25,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    page.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.homeDarkMutedText
                          : AppColors.homeMutedText,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline(String tagline, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.homeDarkSoftSurface
            : AppColors.homeSoftSurface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        tagline,
        style: GoogleFonts.inter(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primarySecondaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildImageContainer(Widget imageWidget, bool isDark) {
    return Container(
      width: 280.w,
      height: 260.h,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.homeDarkSurface
            : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: isDark
              ? AppColors.white10
              : AppColors.primarySecondaryColor.withOpacity(0.12),
          width: 1.5,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.primarySecondaryColor.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient circular glow ring
          Container(
            width: 180.w,
            height: 180.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.homeDarkSoftSurface.withOpacity(0.5)
                  : AppColors.softGreenBg,
            ),
          ),
          imageWidget,
        ],
      ),
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    bool isDark,
    int pageCount,
  ) {
    final app = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 12.h, 28.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page Indicator Dots
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pageCount, (index) {
                final isActive = _controller.currentPage.value == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: isActive ? 28.w : 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: isActive
                        ? AppColors.primarySecondaryColor
                        : (isDark
                            ? AppColors.white10
                            : AppColors.primarySecondaryColor.withOpacity(0.2)),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 24.h),

          // Main CTA Button
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton(
                onPressed: _onNextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarySecondaryColor,
                  foregroundColor: AppColors.whiteColor,
                  elevation: isDark ? 0 : 4,
                  shadowColor: AppColors.primarySecondaryColor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _controller.currentPage.value == pageCount - 1
                          ? (app?.getStarted ?? 'Get Started')
                          : (app?.next ?? 'Next'),
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20.sp,
                      color: AppColors.whiteColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final Widget imageWidget;
  final String tagline;

  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.imageWidget,
    required this.tagline,
  });
}

