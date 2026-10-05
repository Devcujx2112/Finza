import 'package:app/src/data/local/token_storage.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:flutter_test/flutter_test.dart';

/// In memory stand in for the keychain, so the startup language rule can be
/// tested without touching secure storage.
class _FakeTokenStorage implements TokenStorage {
  _FakeTokenStorage({this.language});

  String? language;
  int saveLanguageCalls = 0;

  @override
  Future<String?> getLanguage() async => language;

  @override
  Future<void> saveLanguage(String value) async {
    saveLanguageCalls++;
    language = value;
  }

  @override
  Future<bool?> getDarkMode() async => null;

  @override
  Future<bool?> getBiometricsEnabled() async => null;

  @override
  Future<bool?> getChatWithAIEnabled() async => null;

  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<String?> getEmail() async => null;

  @override
  Future<String?> getPassword() async => null;

  @override
  Future<bool?> getRememberPassword() async => null;

  @override
  Future<void> saveAccessToken(String token) async {}

  @override
  Future<void> saveRefreshToken(String refreshToken) async {}

  @override
  Future<void> saveEmail(String email) async {}

  @override
  Future<void> savePassword(String password) async {}

  @override
  Future<void> saveRememberPassword(bool rememberPassword) async {}

  @override
  Future<void> saveDarkMode(bool isDarkMode) async {}

  @override
  Future<void> saveBiometricsEnabled(bool value) async {}

  @override
  Future<void> saveChatWithAIEnabled(bool value) async {}

  @override
  Future<void> clearTokens() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('startup language', () {
    test('a first launch on a non Vietnamese device lands on English', () async {
      // The test host reports an English locale, standing in for any phone
      // that is not set to Vietnamese.
      final storage = _FakeTokenStorage();
      final controller = MainController(storage);

      await controller.loadSettings();

      expect(controller.languageCode, 'en');
      expect(storage.language, 'en');
    });

    test('a saved Vietnamese choice is kept', () async {
      final storage = _FakeTokenStorage(language: 'vi');
      final controller = MainController(storage);

      await controller.loadSettings();

      expect(controller.languageCode, 'vi');
      expect(controller.selectedLanguageLabel, 'Tiếng Việt');
    });

    test('a language the app does not translate falls back to English', () async {
      final storage = _FakeTokenStorage(language: 'ja');
      final controller = MainController(storage);

      await controller.loadSettings();

      expect(controller.languageCode, 'en');
    });

    test('only the first launch writes the language', () async {
      final storage = _FakeTokenStorage();
      final controller = MainController(storage);

      await controller.loadSettings();
      expect(storage.saveLanguageCalls, 1);

      // A second launch reads the stored value and writes nothing new, so a
      // later change to the phone's language cannot move the app on its own.
      await controller.loadSettings();
      expect(storage.saveLanguageCalls, 1);
    });
  });
}
