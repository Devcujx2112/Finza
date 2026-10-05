import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/profile/profile_controller.dart';
import 'package:app/src/feature/widget/bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with AdaptivePage {
  final ProfileController _controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) =>
      _buildBody(context);

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) =>
      _buildBody(context);

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) =>
      _buildBody(context);

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) =>
      _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      final appLocalizations = AppLocalizations.of(context)!;
      final isDark = _controller.isDarkMode;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.homeDarkBackground
            : AppColors.homeLightBackground,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            appLocalizations.setting,
            style: GoogleFonts.poppins(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.whiteColor : AppColors.lightTextColor,
            ),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 128.h),
          children: [
            _buildSoftProfileHeader(isDark, appLocalizations),
            SizedBox(height: 16.h),

            // Category 1: Preferences
            _buildSectionHeader('PREFERENCES', isDark),
            SizedBox(height: 6.h),
            _buildSectionCard(isDark, [
              _buildSettingTile(
                icon: Icons.fingerprint_rounded,
                title: appLocalizations.loginFaceId,
                trailing: Switch.adaptive(
                  value: _controller.isBiometricsEnabled,
                  activeTrackColor: AppColors.primarySecondaryColor,
                  activeThumbColor: AppColors.whiteColor,
                  onChanged: _controller.setBiometricsEnabled,
                ),
              ),
              _buildSettingTile(
                icon: CupertinoIcons.moon_fill,
                title: appLocalizations.darkMode,
                trailing: Switch.adaptive(
                  value: _controller.isDarkMode,
                  activeTrackColor: AppColors.primarySecondaryColor,
                  activeThumbColor: AppColors.whiteColor,
                  onChanged: _controller.changeModeTheme,
                ),
              ),
              _buildSettingTile(
                icon: CupertinoIcons.chat_bubble_2_fill,
                title: appLocalizations.chatWithAI,
                trailing: Switch.adaptive(
                  value: _controller.isChatWithAIEnabled,
                  activeTrackColor: AppColors.primarySecondaryColor,
                  activeThumbColor: AppColors.whiteColor,
                  onChanged: _controller.setChatWithAIEnabled,
                ),
              ),
            ]),

            SizedBox(height: 16.h),

            // Category 2: Regional & Currency
            _buildSectionHeader('REGIONAL & LOCALIZATION', isDark),
            SizedBox(height: 6.h),
            _buildSectionCard(isDark, [
              _buildSettingTile(
                icon: CupertinoIcons.globe,
                title: appLocalizations.language,
                trailing: _buildTrailingValueBadge(
                  _controller.selectedLanguage,
                  isDark: isDark,
                ),
                onTap: () => _showLanguagePicker(context),
              ),
              _buildSettingTile(
                icon: CupertinoIcons.money_dollar_circle_fill,
                title: appLocalizations.currency,
                trailing: _buildTrailingValueBadge(
                  _controller.selectedCurrency,
                  isDark: isDark,
                ),
                onTap: () => _showCurrencyPicker(context),
              ),
              _buildSettingTile(
                icon: CupertinoIcons.time_solid,
                title: appLocalizations.autoTimezone,
                trailing: Switch.adaptive(
                  value: _controller.isAutoTimezone,
                  activeTrackColor: AppColors.primarySecondaryColor,
                  activeThumbColor: AppColors.whiteColor,
                  onChanged: _controller.setAutoTimezone,
                ),
              ),
              _buildSettingTile(
                icon: CupertinoIcons.location_fill,
                title: appLocalizations.timezone,
                isDisabled: _controller.isAutoTimezone,
                trailing: _buildTrailingValueBadge(
                  _controller.selectedTimezone,
                  isDark: isDark,
                  isDisabled: _controller.isAutoTimezone,
                ),
              ),
            ]),

            SizedBox(height: 16.h),

            // Category 3: Support & Legal
            _buildSectionHeader('SUPPORT & LEGAL', isDark),
            SizedBox(height: 6.h),
            _buildSectionCard(isDark, [
              _buildSettingTile(
                icon: CupertinoIcons.phone_fill,
                title: appLocalizations.contactUs,
                onTap: () {},
              ),
              _buildSettingTile(
                icon: CupertinoIcons.shield_fill,
                title: appLocalizations.privacyPolicy,
                onTap: () {},
              ),
              _buildSettingTile(
                icon: CupertinoIcons.doc_text_fill,
                title: appLocalizations.termsOfService,
                onTap: () {},
              ),
            ]),

            SizedBox(height: 16.h),

            // Category 4: Account Actions
            _buildSectionHeader('ACCOUNT ACTIONS', isDark),
            SizedBox(height: 6.h),
            _buildSectionCard(isDark, [
              _buildSettingTile(
                icon: CupertinoIcons.square_arrow_right_fill,
                title: appLocalizations.logout,
                isDestructive: true,
                onTap: () {},
              ),
              _buildSettingTile(
                icon: CupertinoIcons.trash_fill,
                title: appLocalizations.deleteAccount,
                isCriticalDanger: true,
                onTap: () {},
              ),
            ]),
          ],
        ),
      );
    });
  }

  Widget _buildSoftProfileHeader(
    bool isDark,
    AppLocalizations appLocalizations,
  ) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeDarkSurface : AppColors.homeSurface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark
              ? AppColors.whiteColor.withValues(alpha: 0.08)
              : AppColors.blackColor.withValues(alpha: 0.05),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with subtle green ring & status indicator
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primarySecondaryColor.withValues(
                      alpha: 0.35,
                    ),
                    width: 2.w,
                  ),
                ),
                padding: EdgeInsets.all(2.r),
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.transparentColor,
                  child: ClipOval(
                    child: Image.network(
                      'https://gamek.mediacdn.vn/133514250583805952/2025/9/3/22364594957542295474145163382n-1750237882973423289132-1750240923623-17502409242321933157267-1756872051880-17568720522711720338480-1756884511242-1756884511720618231688.jpg',
                      width: 60.r,
                      height: 60.r,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        CupertinoIcons.person_fill,
                        size: 30.r,
                        color: isDark
                            ? AppColors.homeDarkMutedText
                            : AppColors.homeMutedText,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 1.r,
                right: 1.r,
                child: Container(
                  height: 13.r,
                  width: 13.r,
                  decoration: BoxDecoration(
                    color: AppColors.primarySecondaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.homeDarkSurface
                          : AppColors.homeSurface,
                      width: 2.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trần Hà Linh',
                  style: GoogleFonts.poppins(
                    color: isDark
                        ? AppColors.whiteColor
                        : AppColors.lightTextColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'diannerussel@mail.com',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: isDark
                        ? AppColors.homeDarkMutedText
                        : AppColors.homeMutedText,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(left: 6.w),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: isDark ? AppColors.homeDarkMutedText : AppColors.homeMutedText,
        ),
      ),
    );
  }

  Widget _buildSectionCard(bool isDark, List<Widget> children) {
    final List<Widget> dividedChildren = [];
    for (int i = 0; i < children.length; i++) {
      dividedChildren.add(children[i]);
      if (i < children.length - 1) {
        dividedChildren.add(
          Divider(
            height: 1.h,
            thickness: 0.6,
            indent: 58.w,
            endIndent: 16.w,
            color: isDark
                ? AppColors.whiteColor.withValues(alpha: 0.06)
                : AppColors.blackColor.withValues(alpha: 0.05),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.homeDarkSurface : AppColors.homeSurface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark
              ? AppColors.whiteColor.withValues(alpha: 0.08)
              : AppColors.blackColor.withValues(alpha: 0.05),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: isDark ? 0.18 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: dividedChildren),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    bool isCriticalDanger = false,
    bool isDisabled = false,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color iconColor;
    final Color iconBgColor;

    if (isCriticalDanger) {
      iconColor = AppColors.redColor;
      iconBgColor = isDark
          ? AppColors.profileDestructiveDarkBg
          : AppColors.profileDestructiveLightBg;
    } else if (isDestructive) {
      iconColor = isDark
          ? AppColors.profileDestructiveDark
          : AppColors.errorColor;
      iconBgColor = isDark
          ? AppColors.profileDestructiveDarkBg
          : AppColors.profileDestructiveLightBg;
    } else {
      iconColor = isDark
          ? AppColors.profileDarkIconGreen
          : AppColors.primarySecondaryColor;
      iconBgColor = isDark
          ? AppColors.primarySecondaryColor.withValues(alpha: 0.14)
          : AppColors.primarySecondaryColor.withValues(alpha: 0.08);
    }

    final Color textColor = isCriticalDanger
        ? AppColors.redColor
        : (isDestructive
              ? (isDark
                    ? AppColors.profileDestructiveDark
                    : AppColors.errorColor)
              : (isDark ? AppColors.whiteColor : AppColors.lightTextColor));

    return Opacity(
      opacity: isDisabled ? 0.45 : 1.0,
      child: Material(
        color: AppColors.transparentColor,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 18.sp),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing
                else
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: 14.sp,
                    color: isDark
                        ? AppColors.whiteColor.withValues(alpha: 0.3)
                        : AppColors.blackColor.withValues(alpha: 0.25),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingValueBadge(
    String value, {
    required bool isDark,
    bool isDisabled = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.homeDarkSoftSurface
                : AppColors.homeSoftSurface,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 11.5.sp,
              color: isDark
                  ? AppColors.homeDarkMutedText
                  : AppColors.lightTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (!isDisabled) ...[
          SizedBox(width: 6.w),
          Icon(
            CupertinoIcons.chevron_right,
            size: 13.sp,
            color: isDark
                ? AppColors.whiteColor.withValues(alpha: 0.3)
                : AppColors.blackColor.withValues(alpha: 0.25),
          ),
        ],
      ],
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final languageCode = await BottomNavigation.showPicker<String>(
      context: context,
      items: _controller.languageItems,
      selectedValue: _controller.languageCode,
      title: 'Language',
      subtitle: 'Choose your preferred language',
    );

    if (languageCode == null) return;
    await _controller.changeLanguage(languageCode);
  }

  Future<void> _showCurrencyPicker(BuildContext context) async {
    final currency = await BottomNavigation.showPicker<String>(
      context: context,
      items: _controller.moneyType,
      selectedValue: _controller.selectedCurrency,
      title: 'Currency',
      subtitle: 'Choose your preferred currency',
    );

    if (currency == null) return;
    _controller.setSelectedCurrency(currency);
  }
}
