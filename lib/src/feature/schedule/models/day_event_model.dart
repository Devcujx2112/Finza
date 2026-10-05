import 'package:flutter/material.dart';

/// Where a day event comes from. System events (public holidays and shared
/// observances) are read-only and share one look; user events carry the
/// color and icon their owner picked.
enum DayEventSource { system, user }

/// What kind of day an event marks. Stored by [key] so saved data never
/// depends on enum order.
enum DayEventType {
  birthday('birthday'),
  anniversary('anniversary'),
  special('special'),
  custom('custom'),
  holiday('holiday');

  const DayEventType(this.key);

  final String key;

  /// The types a user can pick. [holiday] is reserved for system events.
  static const List<DayEventType> userSelectable = [
    birthday,
    anniversary,
    special,
    custom,
  ];

  static DayEventType fromKey(String? key) => DayEventType.values.firstWhere(
    (type) => type.key == key,
    orElse: () => DayEventType.custom,
  );
}

/// The icons a user can give a day event. Stored by key, so saved events
/// never depend on icon code points and the catalog can grow safely.
class DayEventIcons {
  const DayEventIcons._();

  static const Map<String, IconData> catalog = <String, IconData>{
    'cake': Icons.cake_outlined,
    'heart': Icons.favorite_border_rounded,
    'star': Icons.star_border_rounded,
    'gift': Icons.card_giftcard_rounded,
    'celebration': Icons.celebration_outlined,
    'family': Icons.family_restroom_rounded,
    'travel': Icons.flight_takeoff_rounded,
    'school': Icons.school_outlined,
    'work': Icons.work_outline_rounded,
    'health': Icons.favorite_outline_rounded,
    'pet': Icons.pets_rounded,
    'bookmark': Icons.bookmark_border_rounded,
  };

  static const String holidayKey = 'flag';

  static IconData resolve(String key) {
    if (key == holidayKey) return Icons.flag_outlined;
    return catalog[key] ?? Icons.bookmark_border_rounded;
  }

  static String defaultFor(DayEventType type) {
    switch (type) {
      case DayEventType.birthday:
        return 'cake';
      case DayEventType.anniversary:
        return 'heart';
      case DayEventType.special:
        return 'star';
      case DayEventType.custom:
        return 'bookmark';
      case DayEventType.holiday:
        return holidayKey;
    }
  }
}

/// Colors a user can give a day event. Every swatch reads as a dot on both
/// the light and the dark calendar surface, and none of them is the holiday
/// red, so a user event can never be mistaken for a public holiday.
class DayEventPalette {
  const DayEventPalette._();

  static const List<Color> swatches = <Color>[
    Color(0xFFD9578B), // rose
    Color(0xFF8B6CEF), // violet
    Color(0xFF276EF1), // blue
    Color(0xFF1FA7A0), // teal
    Color(0xFF35C55F), // green
    Color(0xFFE0A21B), // amber
    Color(0xFFE97845), // orange
    Color(0xFFA9744F), // brown
  ];

  static Color defaultFor(DayEventType type) {
    switch (type) {
      case DayEventType.birthday:
        return swatches[0];
      case DayEventType.anniversary:
        return swatches[1];
      case DayEventType.special:
        return swatches[5];
      case DayEventType.custom:
      case DayEventType.holiday:
        return swatches[3];
    }
  }

  /// The swatch as it should be drawn on the current surface. Dark surfaces
  /// get a lighter tone so icons and dots keep their contrast.
  static Color tone(Color color, bool isDark) =>
      isDark ? Color.lerp(color, Colors.white, 0.22)! : color;
}

/// An event tied to a whole day rather than a time slot: a birthday, an
/// anniversary, a public holiday. Shown on the calendar grid and in the
/// "Day events" section, never in the hourly schedule.
class DayEventModel {
  final String id;
  final String title;
  final DateTime date;
  final DayEventType type;
  final DayEventSource source;

  /// ARGB value of the user's chosen color. Ignored for system events,
  /// which always use the holiday tone.
  final int colorValue;
  final String iconKey;
  final bool repeatsYearly;
  final String? note;

  const DayEventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    required this.colorValue,
    required this.iconKey,
    this.source = DayEventSource.user,
    this.repeatsYearly = false,
    this.note,
  });

  bool get isSystem => source == DayEventSource.system;

  Color get color => Color(colorValue);

  IconData get icon => DayEventIcons.resolve(iconKey);

  bool occursOn(DateTime day) {
    if (repeatsYearly) {
      return date.month == day.month &&
          date.day == day.day &&
          day.year >= date.year;
    }
    return date.year == day.year &&
        date.month == day.month &&
        date.day == day.day;
  }

  DayEventModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    DayEventType? type,
    DayEventSource? source,
    int? colorValue,
    String? iconKey,
    bool? repeatsYearly,
    String? note,
  }) {
    return DayEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      source: source ?? this.source,
      colorValue: colorValue ?? this.colorValue,
      iconKey: iconKey ?? this.iconKey,
      repeatsYearly: repeatsYearly ?? this.repeatsYearly,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': DateTime(date.year, date.month, date.day).toIso8601String(),
    'type': type.key,
    'source': source.name,
    'color': colorValue,
    'icon': iconKey,
    'repeatsYearly': repeatsYearly,
    'note': note,
  };

  factory DayEventModel.fromJson(Map<String, dynamic> json) {
    final type = DayEventType.fromKey(json['type'] as String?);
    return DayEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      type: type,
      source: json['source'] == DayEventSource.system.name
          ? DayEventSource.system
          : DayEventSource.user,
      colorValue:
          (json['color'] as int?) ??
          DayEventPalette.defaultFor(type).toARGB32(),
      iconKey: (json['icon'] as String?) ?? DayEventIcons.defaultFor(type),
      repeatsYearly: json['repeatsYearly'] as bool? ?? false,
      note: json['note'] as String?,
    );
  }
}
