import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/domain/entities/onboarding_setup/cycle_day.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:app/src/feature/onboarding_setup/steps/allocation_step.dart';
import 'package:app/src/feature/onboarding_setup/steps/completion_step.dart';
import 'package:app/src/feature/onboarding_setup/steps/cycle_day_step.dart';
import 'package:app/src/feature/onboarding_setup/steps/fixed_expenses_step.dart';
import 'package:app/src/feature/onboarding_setup/steps/income_step.dart';
import 'package:app/src/feature/onboarding_setup/steps/method_step.dart';
import 'package:app/src/feature/onboarding_setup/steps/saving_goal_step.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_labels.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// The setup questionnaire. One question per screen, a progress bar at the
/// top and a single action at the bottom, so it reads as a guided setup
/// rather than a form.
class OnboardingSetupView extends StatefulWidget {
  const OnboardingSetupView({super.key});

  @override
  State<OnboardingSetupView> createState() => _OnboardingSetupViewState();
}

class _OnboardingSetupViewState extends State<OnboardingSetupView>
    with AdaptivePage {
  final OnboardingSetupController _controller =
      Get.find<OnboardingSetupController>();

  /// Which way the last step change went, used to pick the slide direction.
  bool _isMovingForward = true;

  /// Days offered as a shortlist for the reporting cycle question.
  static const List<int> _analyticsPresetDays = <int>[1, 5, 10, 15, 20, 25];

  /// Pay days cluster later in the month, so this list starts at day 5.
  static const List<int> _incomePresetDays = <int>[5, 10, 15, 20, 25];

  void _goNext() {
    if (_controller.isOnCompletion) {
      _finish();
      return;
    }
    setState(() => _isMovingForward = true);
    _dismissKeyboard();
    _controller.goNext();
  }

  void _goBack() {
    if (!_controller.canGoBack) return;
    setState(() => _isMovingForward = false);
    _dismissKeyboard();
    _controller.goBack();
  }

  void _dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  Future<void> _finish() async {
    await _controller.persist();
    if (!mounted) return;
    Get.offAllNamed(RouterName.navigationMenu);
  }

  @override
  Widget build(BuildContext context) => adaptiveBody(context);

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) => _buildScreen();

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) => _buildScreen();

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) => _buildScreen();

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) => _buildScreen();

  Widget _buildScreen() {
    final palette = SetupPalette.of(context);
    return Obx(() {
      final canGoBack = _controller.canGoBack;
      return PopScope(
        canPop: !canGoBack,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _goBack();
        },
        child: Scaffold(
          backgroundColor: palette.pageBackground,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Obx(() => _buildHeader(palette)),
                Expanded(
                  child: Obx(
                    () => _buildStepBody(palette, _controller.currentStep),
                  ),
                ),
                Obx(() => _buildFooter(palette, _controller.currentStep)),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(SetupPalette palette) {
    final l10n = AppLocalizations.of(context)!;
    // Before a mode is picked the flow length is unknown, so the counter
    // shows the shortest flow rather than collapsing to nothing.
    final stepCount = _controller.questionCount < 2
        ? 2
        : _controller.questionCount;
    final stepNumber = (_controller.stepIndex.value + 1).clamp(1, stepCount);
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
      child: SetupHeader(
        palette: palette,
        stepNumber: stepNumber,
        stepCount: stepCount,
        canGoBack: _controller.canGoBack,
        onBack: _goBack,
        backLabel: l10n.setupBack,
      ),
    );
  }

  /// How far a step travels as it is swapped. Enough to read as forward
  /// motion, short enough that it never feels like a new page arriving.
  static const double _stepSlide = 0.22;

  Widget _buildStepBody(SetupPalette palette, SetupStep step) {
    final forward = _isMovingForward;
    return ClipRect(
      child: AnimatedSwitcher(
        duration: SetupMotion.resolve(context, SetupMotion.stepChange),
        switchInCurve: SetupMotion.curve,
        switchOutCurve: SetupMotion.curve,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        ),
        transitionBuilder: (child, animation) {
          final key = child.key;
          final isIncoming = key is ValueKey<SetupStep> && key.value == step;
          // The step arriving and the step leaving travel in opposite
          // directions. Giving both the same offset is what made one
          // question appear to sit underneath the other.
          final begin = isIncoming
              ? Offset(forward ? _stepSlide : -_stepSlide, 0)
              : Offset(forward ? -_stepSlide : _stepSlide, 0);
          final slide = SlideTransition(
            position: animation.drive(
              Tween<Offset>(begin: begin, end: Offset.zero),
            ),
            child: child,
          );
          // The arriving step stays fully opaque and paints its own
          // background, so it covers the one leaving instead of blending
          // with it. Only the leaving step fades.
          return isIncoming
              ? slide
              : FadeTransition(opacity: animation, child: slide);
        },
        child: KeyedSubtree(
          key: ValueKey<SetupStep>(step),
          child: ColoredBox(
            color: palette.pageBackground,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 28.h),
              child: _buildStepContent(palette, step),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(SetupPalette palette, SetupStep step) {
    final l10n = AppLocalizations.of(context)!;
    switch (step) {
      case SetupStep.method:
        return MethodStep(controller: _controller, palette: palette);
      case SetupStep.analyticsCycleDay:
        return Obx(
          () => CycleDayStep(
            palette: palette,
            title: l10n.setupAnalyticsCycleTitle,
            description: l10n.setupAnalyticsCycleDescription,
            presetDays: _analyticsPresetDays,
            selected: _controller.analyticsCycleDay.value,
            isCustomOpen: _controller.isAnalyticsCustomDayOpen.value,
            onSelectPreset: (day) =>
                _controller.selectAnalyticsCycleDay(CycleDay.onDay(day)),
            onSelectLastDay: () => _controller.selectAnalyticsCycleDay(
              const CycleDay.lastDayOfMonth(),
            ),
            onOpenCustom: _controller.openAnalyticsCustomDay,
            onSelectCustomDay: (day) => _controller.selectAnalyticsCycleDay(
              CycleDay.onDay(day),
              custom: true,
            ),
          ),
        );
      case SetupStep.incomeDay:
        return Obx(
          () => CycleDayStep(
            palette: palette,
            title: l10n.setupIncomeDayTitle,
            description: l10n.setupIncomeDayDescription,
            presetDays: _incomePresetDays,
            selected: _controller.incomeDay.value,
            isCustomOpen: _controller.isIncomeCustomDayOpen.value,
            onSelectPreset: (day) =>
                _controller.selectIncomeDay(CycleDay.onDay(day)),
            onSelectLastDay: () =>
                _controller.selectIncomeDay(const CycleDay.lastDayOfMonth()),
            onOpenCustom: _controller.openIncomeCustomDay,
            onSelectCustomDay: (day) =>
                _controller.selectIncomeDay(CycleDay.onDay(day), custom: true),
          ),
        );
      case SetupStep.income:
        return IncomeStep(controller: _controller, palette: palette);
      case SetupStep.savingGoal:
        return SavingGoalStep(controller: _controller, palette: palette);
      case SetupStep.fixedExpenses:
        return FixedExpensesStep(controller: _controller, palette: palette);
      case SetupStep.allocation:
        return AllocationStep(controller: _controller, palette: palette);
      case SetupStep.completion:
        return CompletionStep(controller: _controller, palette: palette);
    }
  }

  Widget _buildFooter(SetupPalette palette, SetupStep step) {
    final l10n = AppLocalizations.of(context)!;
    final issue = _controller.validationIssue;
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 18.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SetupValidationMessage(
            palette: palette,
            tone: SetupLabels.validationTone(issue),
            message: SetupLabels.validation(
              l10n,
              issue,
              difference: _controller.unallocatedAmount,
            ),
          ),
          SetupPrimaryButton(
            palette: palette,
            label: _primaryLabel(l10n, step),
            isEnabled: _controller.canContinue,
            isBusy: _controller.isSaving.value,
            onTap: _goNext,
          ),
        ],
      ),
    );
  }

  String _primaryLabel(AppLocalizations l10n, SetupStep step) {
    if (step == SetupStep.completion) {
      return _controller.isMidCycle ? l10n.setupMidCycleCta : l10n.setupDoneCta;
    }
    return _controller.isOnLastQuestion ? l10n.setupFinish : l10n.setupContinue;
  }
}
