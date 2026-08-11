import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:app/src/feature/widget/bottom_navigation.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final MainController _mainController = Get.find<MainController>();
  bool get isDarkMode => _mainController.isDarkMode;
  String get selectedLanguage => _mainController.selectedLanguageLabel;
  String get languageCode => _mainController.languageCode;

  final RxBool _isAutoTimezone = true.obs;
  bool get isAutoTimezone => _isAutoTimezone.value;

  final RxString _selectedTimezone = 'GMT+7 (Bangkok/Hanoi)'.obs;
  String get selectedTimezone => _selectedTimezone.value;

  final RxBool _is24hFormat = true.obs;
  bool get is24hFormat => _is24hFormat.value;

  final RxString _selectedCurrency = 'VND (đ)'.obs;
  String get selectedCurrency => _selectedCurrency.value;

  final RxBool _isBiometricsEnabled = true.obs;
  bool get isBiometricsEnabled => _isBiometricsEnabled.value;

  bool get isChatWithAIEnabled => _mainController.isChatWithAIEnabled;

  final List<BottomNavigationPickerItem<String>> languageItems = [
    const BottomNavigationPickerItem(value: 'en', title: 'English'),
    const BottomNavigationPickerItem(value: 'vi', title: 'Tiếng Việt'),
  ];

  final List<BottomNavigationPickerItem<String>> moneyType = [
    const BottomNavigationPickerItem(value: 'VND (đ)', title: 'VND (đ)'),
    const BottomNavigationPickerItem(value: 'USD (\$)', title: 'USD (\$)'),
  ];

  void setBiometricsEnabled(bool value) {
    _isBiometricsEnabled.value = value;
  }

  void changeModeTheme(bool value) {
    _mainController.changeModeTheme(value);
  }

  void setChatWithAIEnabled(bool value) {
    _mainController.enableAI(value);
  }

  Future<void> changeLanguage(String languageCode) {
    return _mainController.changeLanguage(languageCode);
  }

  void setAutoTimezone(bool value) {
    _isAutoTimezone.value = value;
  }

  void set24hFormat(bool value) {
    _is24hFormat.value = value;
  }

  void setSelectedTimezone(String value) {
    _selectedTimezone.value = value;
  }

  void setSelectedCurrency(String value) {
    _selectedCurrency.value = value;
  }
}
