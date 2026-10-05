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

  static const String _defaultLanguageCode = 'en';
  static const String _vietnameseLanguageCode = 'vi';

  final Rx<Locale> _locale = const Locale(_defaultLanguageCode).obs;
  Locale get locale => _locale.value;
  String get languageCode => _locale.value.languageCode;
  String get selectedLanguageLabel =>
      languageCode == _vietnameseLanguageCode ? 'Tiếng Việt' : 'English';

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
    RouterName.onboardingSetup,
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
    final isFirstLaunch = savedLanguage == null;
    final languageCode = _normalizeLanguageCode(
      savedLanguage ?? _deviceLanguageCode,
    );
    _isDarkMode.value = savedDarkMode ?? false;
    _locale.value = Locale(languageCode);
    // The device language decides the language once, on the first launch.
    // Saving it here means a later change to the phone's language does not
    // move the app off what the user has been reading.
    if (isFirstLaunch) {
      await _tokenStorage.saveLanguage(languageCode);
    }
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

  /// The language the phone is set to. Read only on the first launch, to
  /// pick the starting language of the app.
  String get _deviceLanguageCode {
    final dispatcher = ui.PlatformDispatcher.instance;
    final primary = dispatcher.locale.languageCode;
    // `locale` is still undefined this early on some platforms, in which
    // case the preference list is the reliable source.
    if (primary.isNotEmpty && primary != 'und') return primary;
    for (final locale in dispatcher.locales) {
      if (locale.languageCode.isNotEmpty && locale.languageCode != 'und') {
        return locale.languageCode;
      }
    }
    return _defaultLanguageCode;
  }

  /// Vietnamese phones start in Vietnamese. Every other language, including
  /// ones the app has no translation for, starts in English.
  String _normalizeLanguageCode(String languageCode) {
    return languageCode == _vietnameseLanguageCode
        ? _vietnameseLanguageCode
        : _defaultLanguageCode;
  }
}
