import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final String? iconPath;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLength;
  final bool showCounter;
  final bool showDropdown;
  final TextInputType? keyboardType;
  final bool centerLabel;
  final double? labelFontSize;
  final bool showShadow;

  const AppInput({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.iconPath,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.showCounter = false,
    this.showDropdown = false,
    this.keyboardType,
    this.centerLabel = false,
    this.labelFontSize,
    this.showShadow = true,
  });

  void _showDropdown(BuildContext context, List<String> items, TextEditingController controller) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height + 4,
        position.dx + button.size.width,
        position.dy + button.size.height + 120,
      ),
      items: items.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              item,
              style: AppTextStyle.dmSans(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grayDark),
      ),
    ).then((value) {
      if (value != null) {
        controller.text = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.purplePrimary,
          width: 3.w,
        ),
        color: Colors.white,
        boxShadow: showShadow ? [
          BoxShadow(
            color: AppColors.grayDark.withOpacity(0.15),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
            spreadRadius: 2.r,
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: readOnly && onTap != null ? () {
            if (showDropdown) {
              _showDropdown(
                context,
                ['Male', 'Female'],
                controller,
              );
            } else {
              onTap!();
            }
          } : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: readOnly,
                    enabled: !readOnly,
                    maxLength: maxLength,
                    keyboardType: keyboardType,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.dmSans(
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: AppTextStyle.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                      ),
                      counterText: '',
                      isDense: true,
                      isCollapsed: true,
                    ),
                  ),
                ),
                if (iconPath != null)
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: AppIcons(
                      icon: iconPath!,
                      size: 20.w,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 