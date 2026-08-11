import 'dart:ui' as ui;

import 'package:app/router/router_name.dart';
import 'package:app/src/data/local/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  MainController(this._tokenStorage);

  final TokenStorage _tokenStorage;

  final RxBool _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  final Rx<Locale> _locale = const Locale('en').obs;
  Locale get locale => _locale.value;
  String get languageCode => _locale.value.languageCode;
  String get selectedLanguageLabel =>
      languageCode == 'vi' ? 'Tiếng Việt' : 'English';

  final RxBool _isChatWithAIEnabled = false.obs;
  bool get isChatWithAIEnabled => _isChatWithAIEnabled.value;

  final RxBool _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get shouldShowAiChatButton =>
      _isLoggedIn.value &&
      _isChatWithAIEnabled.value &&
      !_excludedAiChatRoutes.contains(_currentRoute.value);

  final RxString _currentRoute = RouterName.splash.obs;
  String get currentRoute => _currentRoute.value;

  final Rxn<Offset> _aiChatButtonOffset = Rxn<Offset>();
  Offset? get aiChatButtonOffset => _aiChatButtonOffset.value;

  static const Set<String> _excludedAiChatRoutes = {
    RouterName.splash,
    RouterName.onboarding,
    RouterName.mainLogin,
    RouterName.login,
    RouterName.signUp,
    RouterName.forgotPassword,
    RouterName.verifyCode,
    RouterName.newPassword,
  };

  Future<void> loadSettings() async {
    final savedDarkMode = await _tokenStorage.getDarkMode();
    final accessToken = await _tokenStorage.getAccessToken();
    final savedLanguage = await _tokenStorage.getLanguage();
    final chatWithAIEnabled = await _tokenStorage.getChatWithAIEnabled();
    final languageCode = _normalizeLanguageCode(
      savedLanguage ?? ui.PlatformDispatcher.instance.locale.languageCode,
    );
    _isDarkMode.value = savedDarkMode ?? false;
    _locale.value = Locale(languageCode);
    _isChatWithAIEnabled.value = chatWithAIEnabled ?? false;
    _isLoggedIn.value = accessToken != null && accessToken.isNotEmpty;
  }

  Future<void> changeModeTheme(bool value) async {
    _isDarkMode.value = value;
    Get.changeThemeMode(themeMode);
    await _tokenStorage.saveDarkMode(value);
  }

  Future<void> enableAI(bool value) async {
    _isChatWithAIEnabled.value = value;
    await _tokenStorage.saveChatWithAIEnabled(value);
  }

  Future<void> changeLanguage(String languageCode) async {
    final normalizedLanguageCode = _normalizeLanguageCode(languageCode);
    final nextLocale = Locale(normalizedLanguageCode);
    _locale.value = nextLocale;
    Get.updateLocale(nextLocale);
    await _tokenStorage.saveLanguage(normalizedLanguageCode);
  }

  Future<void> refreshLoginState() async {
    final accessToken = await _tokenStorage.getAccessToken();
    _isLoggedIn.value = accessToken != null && accessToken.isNotEmpty;
  }

  void updateCurrentRoute(String? route) {
    if (route == null || route.isEmpty) return;
    _currentRoute.value = route;
  }

  void markLoggedOut() {
    _isLoggedIn.value = false;
    _aiChatButtonOffset.value = null;
  }

  void setAiChatButtonOffset(Offset offset) {
    _aiChatButtonOffset.value = offset;
  }

  String _normalizeLanguageCode(String languageCode) {
    return languageCode == 'vi' ? 'vi' : 'en';
  }
}
