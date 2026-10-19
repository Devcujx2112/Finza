import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class SetupWelcomeArgs {
  const SetupWelcomeArgs({
    required this.mode,
    required this.isMidCycle,
    required this.cycleStartDay,
  });

  final ExpenseManagementMode mode;

  final bool isMidCycle;
  final int cycleStartDay;
}

class SetupWelcomeView extends StatefulWidget {
  const SetupWelcomeView({super.key});

  @override
  State<SetupWelcomeView> createState() => _SetupWelcomeViewState();
}

class _SetupWelcomeViewState extends State<SetupWelcomeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  );

  late final Animation<double> _mark = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0, 0.6, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _copy = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _action = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0.45, 1, curve: Curves.easeOutCubic),
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _entrance.value = 1;
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

  String _supportingLine(AppLocalizations l10n) {
    final args = Get.arguments;
    if (args is! SetupWelcomeArgs) return l10n.setupDoneBudgetBody;
    final day = args.cycleStartDay.toString();
    if (args.mode == ExpenseManagementMode.analytics) {
      return l10n.setupDoneAnalyticsBody(day);
    }
    return args.isMidCycle
        ? l10n.setupWelcomeMidCycleBody(day)
        : l10n.setupDoneBudgetBody;
  }

  void _enterApp() => Get.offAllNamed(RouterName.navigationMenu);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = _isDark;
    final background = isDark
        ? AppColors.homeDarkBackground
        : AppColors.homeLightBackground;
    final primaryText = isDark
        ? AppColors.primaryColor
        : AppColors.colorMenuBar;
    final secondaryText = isDark
        ? AppColors.homeDarkMutedText
        : AppColors.homeMutedText;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Spacer(flex: 3),
                        _Reveal(
                          animation: _mark,
                          offset: 0,
                          scaleFrom: 0.88,
                          child: Assets.images.logoApp.svg(
                            height: 76.r,
                            semanticsLabel: 'Finza',
                          ),
                        ),
                        SizedBox(height: 32.h),
                        _Reveal(
                          animation: _copy,
                          offset: 14,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                l10n.setupWelcomeTitle,
                                style: GoogleFonts.poppins(
                                  color: primaryText,
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.18,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                _supportingLine(l10n),
                                style: GoogleFonts.poppins(
                                  color: secondaryText,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(flex: 4),
                        SizedBox(height: 24.h),
                        _Reveal(
                          animation: _action,
                          offset: 10,
                          child: SetupPrimaryButton(
                            palette: SetupPalette.of(context),
                            label: l10n.setupDoneCta,
                            isEnabled: true,
                            onTap: _enterApp,
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

class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.animation,
    required this.child,
    this.offset = 12,
    this.scaleFrom = 1,
  });

  final Animation<double> animation;
  final Widget child;
  final double offset;
  final double scaleFrom;

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
            child: Transform.scale(
              scale: scaleFrom + (1 - scaleFrom) * t,
              alignment: Alignment.centerLeft,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
