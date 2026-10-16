import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetupCategoryIcons {
  const SetupCategoryIcons._();

  static const List<String> suggestions = <String>[
    '🏠',
    '🧾',
    '⚡',
    '🌐',
    '📱',
    '💊',
    '🏋️',
    '💄',
    '🎓',
    '📚',
    '👶',
    '👨‍👩‍👧',
    '🐶',
    '🎁',
    '☕',
    '✈️',
    '🚗',
    '⛽',
    '👕',
    '🎮',
    '🎵',
    '⚽',
    '💰',
    '🤝',
  ];

  static const Map<String, String> _legacyKeys = <String, String>{
    'home': '🏠',
    'bills': '🧾',
    'electric': '⚡',
    'internet': '🌐',
    'phone': '📱',
    'health': '💊',
    'fitness': '🏋️',
    'beauty': '💄',
    'education': '🎓',
    'books': '📚',
    'kids': '👶',
    'family': '👨‍👩‍👧',
    'pets': '🐶',
    'gift': '🎁',
    'coffee': '☕',
    'travel': '✈️',
    'car': '🚗',
    'fuel': '⛽',
    'clothes': '👕',
    'games': '🎮',
    'music': '🎵',
    'sport': '⚽',
    'savings': '💰',
    'charity': '🤝',
  };

  static const String fallback = '📦';

  static const String fixedCost = '🧾';

  static String get defaultKey => suggestions.first;

  static bool isEmoji(String value) =>
      value.isNotEmpty && value.runes.any((rune) => rune >= 0x2190);

  static String resolve(String key) {
    final legacy = _legacyKeys[key];
    if (legacy != null) return legacy;
    if (isEmoji(key)) return key;
    return fallback;
  }
}

class CategoryEmoji extends StatelessWidget {
  const CategoryEmoji(this.iconKey, {super.key, this.size = 18});

  final String iconKey;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      SetupCategoryIcons.resolve(iconKey),
      textScaler: TextScaler.noScaling,
      style: TextStyle(fontSize: size.sp, height: 1.15),
    );
  }
}

@immutable
class CategoryEmojiPickerStyle {
  const CategoryEmojiPickerStyle({
    required this.fill,
    required this.selectedFill,
    required this.border,
    required this.selectedBorder,
    required this.primaryText,
    required this.secondaryText,
    required this.sheetBackground,
  });

  final Color fill;
  final Color selectedFill;
  final Color border;
  final Color selectedBorder;
  final Color primaryText;
  final Color secondaryText;
  final Color sheetBackground;
}

class CategoryEmojiPicker extends StatelessWidget {
  const CategoryEmojiPicker({
    super.key,
    required this.style,
    required this.selected,
    required this.onSelected,
  });

  final CategoryEmojiPickerStyle style;
  final String selected;
  final ValueChanged<String> onSelected;

  Future<void> _openCatalogue(BuildContext context, String current) async {
    final picked = await showEmojiCatalogueSheet(
      context,
      style: style,
      selected: current,
    );
    if (picked != null) onSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final current = SetupCategoryIcons.resolve(selected);
    final isFromCatalogue = !SetupCategoryIcons.suggestions.contains(current);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          children: <Widget>[
            for (final emoji in SetupCategoryIcons.suggestions)
              _EmojiTile(
                style: style,
                isSelected: emoji == current,
                onTap: () => onSelected(emoji),
                child: CategoryEmoji(emoji, size: 21),
              ),
          ],
        ),
        SizedBox(height: 10.h),
        Semantics(
          button: true,
          label: l10n.setupEmojiMore,
          child: SetupPressable(
            onTap: () => _openCatalogue(context, current),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 48.r,
                  height: 48.r,
                  child: AnimatedContainer(
                    duration: SetupMotion.resolve(
                      context,
                      SetupMotion.selection,
                    ),
                    curve: SetupMotion.curve,
                    alignment: Alignment.center,
                    decoration: _tileDecoration(style, isFromCatalogue),
                    child: isFromCatalogue
                        ? CategoryEmoji(current, size: 21)
                        : Icon(
                            Icons.apps_rounded,
                            size: 20.sp,
                            color: style.secondaryText,
                          ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    l10n.setupEmojiMore,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: style.primaryText,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.sp,
                  color: style.secondaryText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmojiTile extends StatelessWidget {
  const _EmojiTile({
    required this.style,
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  final CategoryEmojiPickerStyle style;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: SetupPressable(
        onTap: onTap,
        scale: 0.92,
        child: AnimatedContainer(
          duration: SetupMotion.resolve(context, SetupMotion.selection),
          curve: SetupMotion.curve,
          alignment: Alignment.center,
          decoration: _tileDecoration(style, isSelected),
          child: child,
        ),
      ),
    );
  }
}

BoxDecoration _tileDecoration(CategoryEmojiPickerStyle style, bool selected) =>
    BoxDecoration(
      color: selected ? style.selectedFill : style.fill,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(
        color: selected ? style.selectedBorder : style.border,
        width: selected ? 1.5.w : 1.w,
      ),
    );

enum EmojiGroup {
  food,
  shopping,
  transport,
  home,
  health,
  fun,
  family,
  work,
  other,
}

const Map<EmojiGroup, List<String>> _catalogue = <EmojiGroup, List<String>>{
  EmojiGroup.food: <String>[
    '🍜',
    '🍚',
    '🍲',
    '🍝',
    '🍕',
    '🍔',
    '🍟',
    '🌭',
    '🥪',
    '🌮',
    '🍣',
    '🍱',
    '🥗',
    '🍳',
    '🥐',
    '🍞',
    '🍰',
    '🍩',
    '🍪',
    '🍦',
    '☕',
    '🧋',
    '🍵',
    '🥤',
    '🍺',
    '🍷',
    '🍎',
    '🍌',
    '🥦',
    '🛒',
  ],
  EmojiGroup.shopping: <String>[
    '🛍️',
    '👕',
    '👖',
    '👗',
    '👟',
    '👠',
    '👜',
    '🎒',
    '👓',
    '⌚',
    '💍',
    '💄',
    '🧴',
    '🧸',
    '🎁',
    '📦',
    '💻',
    '📱',
    '🎧',
    '📷',
    '🖥️',
    '🪑',
    '🛋️',
    '🛒',
  ],
  EmojiGroup.transport: <String>[
    '🚕',
    '🚗',
    '🚙',
    '🏍️',
    '🛵',
    '🚲',
    '🚌',
    '🚆',
    '🚇',
    '✈️',
    '🚢',
    '⛽',
    '🅿️',
    '🔧',
    '🛞',
    '🗺️',
  ],
  EmojiGroup.home: <String>[
    '🏠',
    '🏢',
    '🔑',
    '💡',
    '⚡',
    '💧',
    '🔥',
    '🌐',
    '📶',
    '📱',
    '🧾',
    '🧹',
    '🧺',
    '🛏️',
    '🚿',
    '🪴',
    '🔨',
    '📺',
  ],
  EmojiGroup.health: <String>[
    '💊',
    '🏥',
    '🩺',
    '🦷',
    '👓',
    '🧘',
    '🏋️',
    '🏃',
    '💆',
    '💇',
    '💅',
    '🧴',
    '🛁',
    '😷',
  ],
  EmojiGroup.fun: <String>[
    '🎮',
    '🎬',
    '🍿',
    '🎵',
    '🎤',
    '🎸',
    '🎨',
    '📚',
    '🎭',
    '🎟️',
    '⚽',
    '🏀',
    '🏸',
    '🎳',
    '🏖️',
    '⛺',
    '🎡',
    '🎉',
  ],
  EmojiGroup.family: <String>[
    '👶',
    '🍼',
    '🧒',
    '👨‍👩‍👧',
    '👵',
    '💑',
    '💐',
    '🎂',
    '🎁',
    '🏫',
    '🐶',
    '🐱',
    '🐟',
    '🐦',
    '🐾',
    '🦴',
  ],
  EmojiGroup.work: <String>[
    '💼',
    '🎓',
    '📚',
    '✏️',
    '📝',
    '💻',
    '🖨️',
    '📊',
    '📈',
    '🏦',
    '💳',
    '💰',
    '💵',
    '🪙',
    '🤝',
    '📮',
  ],
  EmojiGroup.other: <String>[
    '📦',
    '⭐',
    '❤️',
    '🔔',
    '📌',
    '🗓️',
    '⏰',
    '🧩',
    '🎯',
    '🛡️',
    '⚖️',
    '🙏',
    '♻️',
    '🌱',
    '☀️',
    '🌧️',
  ],
};

String _groupLabel(AppLocalizations l10n, EmojiGroup group) => switch (group) {
  EmojiGroup.food => l10n.setupEmojiGroupFood,
  EmojiGroup.shopping => l10n.setupEmojiGroupShopping,
  EmojiGroup.transport => l10n.setupEmojiGroupTransport,
  EmojiGroup.home => l10n.setupEmojiGroupHome,
  EmojiGroup.health => l10n.setupEmojiGroupHealth,
  EmojiGroup.fun => l10n.setupEmojiGroupFun,
  EmojiGroup.family => l10n.setupEmojiGroupFamily,
  EmojiGroup.work => l10n.setupEmojiGroupWork,
  EmojiGroup.other => l10n.setupEmojiGroupOther,
};

Future<String?> showEmojiCatalogueSheet(
  BuildContext context, {
  required CategoryEmojiPickerStyle style,
  required String selected,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EmojiCatalogueSheet(style: style, selected: selected),
  );
}

class _EmojiCatalogueSheet extends StatefulWidget {
  const _EmojiCatalogueSheet({required this.style, required this.selected});

  final CategoryEmojiPickerStyle style;
  final String selected;

  @override
  State<_EmojiCatalogueSheet> createState() => _EmojiCatalogueSheetState();
}

class _EmojiCatalogueSheetState extends State<_EmojiCatalogueSheet> {
  late EmojiGroup _group = EmojiGroup.values.firstWhere(
    (group) => _catalogue[group]!.contains(widget.selected),
    orElse: () => EmojiGroup.food,
  );

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final l10n = AppLocalizations.of(context)!;
    final media = MediaQuery.of(context);

    return Container(
      height: media.size.height * 0.62,
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, media.padding.bottom + 8.h),
      decoration: BoxDecoration(
        color: style.sheetBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: style.border,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              l10n.setupEmojiSheetTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: style.primaryText,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 38.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: EmojiGroup.values.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                final group = EmojiGroup.values[index];
                final isActive = group == _group;
                return Semantics(
                  button: true,
                  selected: isActive,
                  child: GestureDetector(
                    onTap: () => setState(() => _group = group),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: SetupMotion.resolve(
                        context,
                        SetupMotion.selection,
                      ),
                      curve: SetupMotion.curve,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: isActive ? style.selectedFill : style.fill,
                        borderRadius: BorderRadius.circular(999.r),
                        border: Border.all(
                          color: isActive ? style.selectedBorder : style.border,
                          width: 1.w,
                        ),
                      ),
                      child: Text(
                        _groupLabel(l10n, group),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? style.primaryText
                              : style.secondaryText,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: GridView.count(
              crossAxisCount: 6,
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 12.h),
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              children: <Widget>[
                for (final emoji in _catalogue[_group]!)
                  _EmojiTile(
                    style: style,
                    isSelected: emoji == widget.selected,
                    onTap: () => Navigator.of(context).pop(emoji),
                    child: CategoryEmoji(emoji, size: 22),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
