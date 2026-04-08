import 'package:app/domain/entities/bottom_bar/menubar_item.dart';
import 'package:app/router/router_name.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  List<MenubarItem> menuUser = [
    MenubarItem(menuId: 0, title: "Home", location: RouterName.home),
    MenubarItem(menuId: 1, title: "Schedule", location: RouterName.schedule),
    MenubarItem(menuId: 2, title: "Budget", location: RouterName.budget),
    MenubarItem(menuId: 3, title: "Profile", location: RouterName.profile),
  ];

  List<MenubarItem> menuAdmin = [
    MenubarItem(menuId: 0, title: "Home", location: RouterName.home),
    MenubarItem(menuId: 1, title: "Schedule", location: RouterName.schedule),
    MenubarItem(menuId: 2, title: "Budget", location: RouterName.budget),
    MenubarItem(menuId: 3, title: "Profile", location: RouterName.profile),
    MenubarItem(menuId: 4, title: "Admin", location: RouterName.admin),
  ];

  RxInt currentIndex = 0.obs;
}
