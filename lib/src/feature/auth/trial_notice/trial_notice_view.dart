import 'package:app/gen/assets.gen.dart';
import 'package:app/gen/fonts.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TrialNoticeView extends StatefulWidget {
  const TrialNoticeView({super.key});

  @override
  State<TrialNoticeView> createState() => _TrialNoticeViewState();
}

class _TrialNoticeViewState extends State<TrialNoticeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  late final Animation<double> _headerAnim = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0, 0.5, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _cardsAnim = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.2, 0.75, curve: Curves.easeOutCubic),
  );

  late final Animation<double> _actionsAnim = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _entrance.value = 1.0;
    } else {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  bool get _isDark {
    final appIsDark =
        Get.isRegistered<MainController>() &&
        Get.find<MainController>().isDarkMode;
    return appIsDark || Theme.of(context).brightness == Brightness.dark;
  }

  void _onContinue() {
    Get.offNamed(
      RouterName.onboardingSetup,
      arguments: const <String, dynamic>{'isTrial': true},
    );
  }

  void _onCreateAccount() {
    Get.toNamed(RouterName.signUp);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = _isDark;

    final background = isDark
        ? AppColors.homeDarkBackground
        : AppColors.homeLightBackground;
    final surface = isDark ? AppColors.homeDarkSurface : AppColors.whiteColor;
    final primaryText = isDark
        ? AppColors.primaryColor
        : AppColors.setupPrimaryText;
    final secondaryText = isDark
        ? AppColors.homeDarkMutedText
        : AppColors.setupSecondaryText;
    final border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : AppColors.setupBorder;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header section with animated entrance
                        _Reveal(
                          animation: _headerAnim,
                          offset: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Assets.images.logoApp.svg(
                                    height: 38.r,
                                    semanticsLabel: 'Finza',
                                  ),
                                  _TrialBadge(l10n: l10n, isDark: isDark),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                l10n.trialNoticeTitle,
                                style: TextStyle(
                                  fontFamily: FontFamily.roboto,
                                  color: primaryText,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                l10n.trialNoticeSubtitle,
                                style: TextStyle(
                                  fontFamily: FontFamily.roboto,
                                  color: secondaryText,
                                  fontSize: 14.sp,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Features comparison section
                        _Reveal(
                          animation: _cardsAnim,
                          offset: 14,
                          child: Column(
                            children: [
                              // Feature 1: Analytics Mode (Available)
                              _FeatureCard(
                                isDark: isDark,
                                surface: surface,
                                border: AppColors.accentGreen.withValues(
                                  alpha: 0.35,
                                ),
                                iconBg: isDark
                                    ? const Color(0xFF0E3A2F)
                                    : AppColors.softGreenBg,
                                iconColor: AppColors.accentGreen,
                                icon: CupertinoIcons.chart_pie_fill,
                                title: l10n.trialNoticeAnalyticsTitle,
                                description: l10n.trialNoticeAnalyticsDesc,
                                statusLabel: l10n.trialNoticeAnalyticsBadge,
                                statusIsPositive: true,
                              ),

                              SizedBox(height: 14.h),

                              // Feature 2: Budget Mode (Locked / Account Required)
                              _FeatureCard(
                                isDark: isDark,
                                surface: surface,
                                border: border,
                                iconBg: isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.black.withValues(alpha: 0.04),
                                iconColor: isDark
                                    ? AppColors.greyShade400
                                    : AppColors.greyShade600,
                                icon: CupertinoIcons.lock_shield_fill,
                                title: l10n.trialNoticeBudgetTitle,
                                description: l10n.trialNoticeBudgetDesc,
                                statusLabel: l10n.trialNoticeBudgetBadge,
                                statusIsPositive: false,
                              ),

                              SizedBox(height: 18.h),

                              // Hint Box about upcoming cycle day selection
                              Container(
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF082622)
                                      : const Color(0xFFEFF9F2),
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: AppColors.accentGreen.withValues(
                                      alpha: 0.22,
                                    ),
                                    width: 1.w,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.h),
                                      child: Icon(
                                        CupertinoIcons.calendar,
                                        size: 18.sp,
                                        color: AppColors.accentGreen,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        l10n.trialNoticeCycleHint,
                                        style: TextStyle(
                                          fontFamily: FontFamily.roboto,
                                          fontSize: 13.sp,
                                          color: isDark
                                              ? AppColors.homeDarkMutedText
                                              : AppColors.setupPrimaryText,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        SizedBox(height: 24.h),

                        // Actions Section
                        _Reveal(
                          animation: _actionsAnim,
                          offset: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Primary Action: Continue to setup cycle day
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  onPressed: _onContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accentGreen,
                                    foregroundColor: AppColors.whiteColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        l10n.trialNoticeContinue,
                                        style: TextStyle(
                                          fontFamily: FontFamily.roboto,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        CupertinoIcons.arrow_right,
                                        size: 18.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 10.h),

                              // Secondary Action: Register full account
                              SizedBox(
                                width: double.infinity,
                                height: 44.h,
                                child: TextButton(
                                  onPressed: _onCreateAccount,
                                  style: TextButton.styleFrom(
                                    foregroundColor: isDark
                                        ? AppColors.homeDarkMutedText
                                        : AppColors.lightTextColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.trialNoticeCreateAccount,
                                    style: TextStyle(
                                      fontFamily: FontFamily.roboto,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrialBadge extends StatelessWidget {
  const _TrialBadge({required this.l10n, required this.isDark});

  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F3A2E) : AppColors.softGreenBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.accentGreen.withValues(alpha: 0.4),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.sparkles,
            size: 13.sp,
            color: AppColors.accentGreen,
          ),
          SizedBox(width: 5.w),
          Text(
            l10n.trialNoticeBadge,
            style: TextStyle(
              fontFamily: FontFamily.roboto,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.whiteColor : AppColors.accentGreenDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.isDark,
    required this.surface,
    required this.border,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.description,
    required this.statusLabel,
    required this.statusIsPositive,
  });

  final bool isDark;
  final Color surface;
  final Color border;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String description;
  final String statusLabel;
  final bool statusIsPositive;

  @override
  Widget build(BuildContext context) {
    final statusColor = statusIsPositive
        ? AppColors.accentGreen
        : (isDark ? AppColors.greyShade400 : AppColors.greyShade600);
    final statusBg = statusIsPositive
        ? (isDark ? const Color(0xFF0F3A2E) : AppColors.softGreenBg)
        : (isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.04));

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: border, width: 1.2.w),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20.sp, color: iconColor),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: FontFamily.roboto,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.primaryColor
                        : AppColors.setupPrimaryText,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.35),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIsPositive
                          ? CupertinoIcons.checkmark_alt
                          : CupertinoIcons.lock_fill,
                      size: 11.sp,
                      color: statusColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontFamily: FontFamily.roboto,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            description,
            style: TextStyle(
              fontFamily: FontFamily.roboto,
              fontSize: 13.sp,
              color: isDark
                  ? AppColors.homeDarkMutedText
                  : AppColors.setupSecondaryText,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.animation,
    required this.child,
    this.offset = 12,
  });

  final Animation<double> animation;
  final Widget child;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * offset),
            child: child,
          ),
        );
      },
    );
  }
}
