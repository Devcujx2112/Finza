import 'package:app/src/feature/bottom_bar/bottom_bar.dart';
import 'package:app/src/feature/bottom_bar/bottom_bar_controller.dart';
import 'package:app/src/feature/budget/budget_view.dart';
import 'package:app/src/feature/home/homepage_view.dart';
import 'package:app/src/feature/profile/profile_view.dart';
import 'package:app/src/feature/schedule/schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationView extends StatelessWidget {
  NavigationView({super.key});

  final BottomBarController controller = Get.find<BottomBarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Obx(
            () {
              final currentIndex = controller.currentIndex.value;
              final previousIndex = controller.previousIndex.value;
              final isForward = currentIndex > previousIndex;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                transitionBuilder: (child, animation) {
                  final key = child.key;
                  final childIndex = key is ValueKey<int> ? key.value : 0;
                  final isIncoming = childIndex == currentIndex;
                  final beginOffset = isIncoming
                      ? Offset(isForward ? 1 : -1, 0)
                      : Offset(isForward ? -1 : 1, 0);
                  final position = Tween<Offset>(
                    begin: beginOffset,
                    end: Offset.zero,
                  ).animate(animation);

                  return SlideTransition(position: position, child: child);
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(currentIndex),
                  child: _buildCurrentPage(currentIndex),
                ),
              );
            },
          ),
          const BottomBar(),
        ],
      ),
    );
  }

  Widget _buildCurrentPage(int index) {
    switch (index) {
      case 1:
        return const ScheduleView();
      case 2:
        return const BudgetView();
      case 3:
        return const ProfileView();
      case 0:
      default:
        return const HomepageView();
    }
  }
}
