import 'package:flutter/material.dart';

/// The icons a user can give a custom category. Stored by key, so the saved
/// configuration never depends on icon code points, and the catalog can be
/// reordered or extended without breaking anything already saved.
class SetupCategoryIcons {
  const SetupCategoryIcons._();

  static const Map<String, IconData> catalog = <String, IconData>{
    'home': Icons.home_outlined,
    'bills': Icons.receipt_long_outlined,
    'electric': Icons.bolt_rounded,
    'internet': Icons.wifi_rounded,
    'phone': Icons.smartphone_rounded,
    'health': Icons.medical_services_outlined,
    'fitness': Icons.fitness_center_rounded,
    'beauty': Icons.spa_outlined,
    'education': Icons.school_outlined,
    'books': Icons.menu_book_rounded,
    'kids': Icons.child_friendly_outlined,
    'family': Icons.family_restroom_rounded,
    'pets': Icons.pets_rounded,
    'gift': Icons.card_giftcard_rounded,
    'coffee': Icons.local_cafe_outlined,
    'travel': Icons.flight_takeoff_rounded,
    'car': Icons.directions_car_outlined,
    'fuel': Icons.local_gas_station_outlined,
    'clothes': Icons.checkroom_rounded,
    'games': Icons.sports_esports_outlined,
    'music': Icons.music_note_rounded,
    'sport': Icons.sports_soccer_rounded,
    'savings': Icons.savings_outlined,
    'charity': Icons.volunteer_activism_outlined,
  };

  static String get defaultKey => catalog.keys.first;

  /// Falls back to a neutral icon for a key this build does not know, such
  /// as one saved by a newer version of the app.
  static IconData resolve(String key) =>
      catalog[key] ?? Icons.category_outlined;
}
