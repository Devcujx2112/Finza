import 'package:app/domain/entities/bottom_bar/menubar_item.dart';
import 'package:app/router/router_name.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  List<MenubarItem> menuUser = [
    MenubarItem(menuId: 0, location: RouterName.home),
    MenubarItem(menuId: 1, location: RouterName.schedule),
    MenubarItem(menuId: 2, location: RouterName.budget),
    MenubarItem(menuId: 3, location: RouterName.profile),
  ];

  List<MenubarItem> menuAdmin = [
    MenubarItem(menuId: 0, location: RouterName.home),
    MenubarItem(menuId: 1, location: RouterName.schedule),
    MenubarItem(menuId: 2, location: RouterName.budget),
    MenubarItem(menuId: 3, location: RouterName.profile),
    MenubarItem(menuId: 4, location: RouterName.admin),
  ];

  RxInt previousIndex = 0.obs;
  RxInt currentIndex = 0.obs;

  void changeTap(int index) {
    if (currentIndex.value == index) return;
    previousIndex.value = currentIndex.value;
    currentIndex.value = index;
  }
}
