import 'package:app/src/feature/bottom_bar/model/menubar_item.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  List<MenubarItem> menuUser = [
    MenubarItem(menuId: 0, title: "Home", location: "/home"),
    MenubarItem(menuId: 1, title: "Schedule", location: "/schedule"),
    MenubarItem(menuId: 2, title: "Budget", location: "/budget"),
    MenubarItem(menuId: 3, title: "Profile", location: "/profile"),
  ];

  List<MenubarItem> menuAdmin = [
    MenubarItem(menuId: 0, title: "Home", location: "/home"),
    MenubarItem(menuId: 1, title: "Schedule", location: "/schedule"),
    MenubarItem(menuId: 2, title: "Budget", location: "/budget"),
    MenubarItem(menuId: 3, title: "Profile", location: "/profile"),
    MenubarItem(menuId: 4, title: "Admin", location: "/admin"),
  ];

  RxInt currentIndex = 0.obs;
}
