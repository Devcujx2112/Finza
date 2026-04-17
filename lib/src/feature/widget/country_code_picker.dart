import 'package:app/domain/entities/country_code/country_code.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryCodePicker extends StatelessWidget {
  final List<CountryCode> countries;
  final String selectedCode;
  final Function(String) onSelected;

  const CountryCodePicker({
    super.key,
    required this.countries,
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        width: 55.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.buttonLogin,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          selectedCode,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.buttonRegister,
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: _BottomSheetContent(
            countries: countries,
            selectedCode: selectedCode,
          ),
        );
      },
    );

    if (result != null) {
      onSelected(result);
    }
  }
}

class _BottomSheetContent extends StatelessWidget {
  final List<CountryCode> countries;
  final String selectedCode;

  const _BottomSheetContent({
    required this.countries,
    required this.selectedCode,
  });

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context);
    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.buttonLogin,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocal?.selectCountryCode ?? "",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonRegister,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: AppColors.buttonRegister),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final item = countries[index];
                  final isSelected = item.dialCode == selectedCode;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, item.dialCode);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      color: isSelected
                          ? AppColors.buttonLogin.withOpacity(0.2)
                          : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Tên quốc gia
                          Expanded(
                            child: Text(
                              item.nameCountry,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),

                          Text(
                            item.dialCode,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.errorColor
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
