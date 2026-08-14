import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/profile/profile_controller.dart';
import 'package:app/src/feature/widget/bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
            ? AppColors.profileDarkBackground
            : AppColors.profileLightBackground,
        appBar: AppBar(
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            appLocalizations.setting,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.whiteColor : AppColors.lightTextColor,
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 120.h),
            children: [
              _buildProfileHeader(isDark, appLocalizations),
              SizedBox(height: 8.h),
              _buildSectionCard(isDark, [
                _buildSettingTile(
                  icon: Icons.fingerprint_rounded,
                  title: appLocalizations.loginFaceId,
                  trailing: Switch.adaptive(
                    value: _controller.isBiometricsEnabled,
                    activeColor: AppColors.primarySecondaryColor,
                    onChanged: _controller.setBiometricsEnabled,
                  ),
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.moon,
                  title: appLocalizations.darkMode,
                  trailing: Switch.adaptive(
                    value: _controller.isDarkMode,
                    activeColor: AppColors.primarySecondaryColor,
                    onChanged: _controller.changeModeTheme,
                  ),
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.chat_bubble_2,
                  title: appLocalizations.chatWithAI,
                  trailing: Switch.adaptive(
                    value: _controller.isChatWithAIEnabled,
                    activeColor: AppColors.primarySecondaryColor,
                    onChanged: _controller.setChatWithAIEnabled,
                  ),
                ),
              ]),
              SizedBox(height: 16.h),
              _buildSectionCard(isDark, [
                _buildSettingTile(
                  icon: CupertinoIcons.globe,
                  title: appLocalizations.language,
                  trailing: _buildTrailingValueText(
                    _controller.selectedLanguage,
                  ),
                  onTap: () => _showLanguagePicker(context),
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.money_dollar_circle,
                  title: appLocalizations.currency,
                  trailing: _buildTrailingValueText(
                    _controller.selectedCurrency,
                  ),
                  onTap: () => _showCurrencyPicker(context),
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.clock,
                  title: appLocalizations.autoTimezone,
                  trailing: Switch.adaptive(
                    value: _controller.isAutoTimezone,
                    activeColor: AppColors.buttonLogin,
                    onChanged: _controller.setAutoTimezone,
                  ),
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.map,
                  title: appLocalizations.timezone,
                  trailing: Opacity(
                    opacity: _controller.isAutoTimezone ? 0.5 : 1.0,
                    child: _buildTrailingValueText(
                      _controller.selectedTimezone,
                    ),
                  ),
                  // onTap: _controller.isAutoTimezone
                  //     ? null
                  //     : () => _showTimezonePicker(context),
                ),
                // _buildSettingTile(
                //   icon: CupertinoIcons.clock,
                //   title: appLocalizations.format12h24h,
                //   trailing: Switch.adaptive(
                //     value: _controller.is24hFormat,
                //     activeColor: AppColors.primarySecondaryColor,
                //     onChanged: _controller.set24hFormat,
                //   ),
                // ),
              ]),
              SizedBox(height: 16.h),
              _buildSectionCard(isDark, [
                _buildSettingTile(
                  icon: CupertinoIcons.phone,
                  title: appLocalizations.contactUs,
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.shield,
                  title: appLocalizations.privacyPolicy,
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.doc_text,
                  title: appLocalizations.termsOfService,
                  onTap: () {},
                ),
              ]),
              SizedBox(height: 16.h),
              _buildSectionCard(isDark, [
                _buildSettingTile(
                  icon: CupertinoIcons.square_arrow_right,
                  title: appLocalizations.logout,
                  isDestructive: true,
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.trash,
                  title: appLocalizations.deleteAccount,
                  isDestructive: true,
                  onTap: () {},
                ),
              ]),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileHeader(bool isDark, AppLocalizations appLocalizations) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primarySecondaryColor,
                      AppColors.buttonLogin,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primarySecondaryColor.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(3.r),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppColors.profileDarkSurface : AppColors.whiteColor,
                  ),
                  padding: EdgeInsets.all(2.r),
                  child: CircleAvatar(
                    radius: 36.r,
                    backgroundColor: AppColors.transparentColor,
                    child: ClipOval(
                      child: Image.network(
                        'https://gamek.mediacdn.vn/133514250583805952/2025/9/3/22364594957542295474145163382n-1750237882973423289132-1750240923623-17502409242321933157267-1756872051880-17568720522711720338480-1756884511242-1756884511720618231688.jpg',
                        width: 72.r,
                        height: 72.r,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          CupertinoIcons.person_fill,
                          size: 36.r,
                          color: isDark
                              ? AppColors.white70
                              : AppColors.lightTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trần Hà Linh',
                      style: TextStyle(
                        color: isDark ? AppColors.whiteColor : AppColors.lightTextColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'diannerussel@mail.com',
                      style: TextStyle(
                        color: isDark ? AppColors.white70 : AppColors.greyShade600,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primarySecondaryColor,
                    AppColors.buttonLogin,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primarySecondaryColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.pencil, size: 18.sp, color: AppColors.whiteColor),
                  SizedBox(width: 6.w),
                  Text(
                    appLocalizations.edit,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            height: 1,
            thickness: 0.5,
            indent: 56.w,
            endIndent: 16.w,
            color: isDark ? AppColors.white10 : AppColors.greyShade200,
          ),
        );
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.profileDarkSurface : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.whiteColor.withOpacity(0.06)
              : AppColors.blackColor.withOpacity(0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.blackColor.withOpacity(isDark ? 0.15 : 0.02),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium Cohesive Palette logic
    final Color iconColor;
    final Color iconBgColor;

    if (isDestructive) {
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
          // ignore: deprecated_member_use
          ? AppColors.primarySecondaryColor.withOpacity(0.15)
          // ignore: deprecated_member_use
          : AppColors.primarySecondaryColor.withOpacity(0.08);
    }

    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.whiteColor : AppColors.lightTextColor,
                  ),
                ),
              ),
              if (trailing != null)
                trailing
              else
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 14.sp,
                  color: isDark ? AppColors.greyShade600 : AppColors.greyShade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailingValueText(String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? AppColors.greyShade400 : AppColors.greyShade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 6.w),
        Icon(
          CupertinoIcons.chevron_right,
          size: 12.sp,
          color: isDark ? AppColors.greyShade600 : AppColors.greyShade400,
        ),
      ],
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final languageCode = await BottomNavigation.showPicker<String>(
      context: context,
      items: _controller.languageItems,
    );

    if (languageCode == null) return;
    await _controller.changeLanguage(languageCode);
  }

  Future<void> _showCurrencyPicker(BuildContext context) async {
    final currency = await BottomNavigation.showPicker<String>(
      context: context,
      items: _controller.moneyType
    );

    if (currency == null) return;
    _controller.setSelectedCurrency(currency);
  }

  // Future<void> _showTimezonePicker(BuildContext context) async {
  //   final timezone = await BottomNavigation.showPicker<String>(
  //     context: context,
  //     items: const [
  //       BottomNavigationPickerItem(
  //         value: 'GMT+7 (Bangkok/Hanoi)',
  //         title: 'GMT+7 (Bangkok/Hanoi)',
  //       ),
  //       BottomNavigationPickerItem(
  //         value: 'GMT+8 (Singapore)',
  //         title: 'GMT+8 (Singapore)',
  //       ),
  //       BottomNavigationPickerItem(
  //         value: 'GMT+9 (Tokyo/Seoul)',
  //         title: 'GMT+9 (Tokyo/Seoul)',
  //       ),
  //     ],
  //   );

  //   if (timezone == null) return;
  //   _controller.setSelectedTimezone(timezone);
  // }
}
