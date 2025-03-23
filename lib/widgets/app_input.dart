import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_icons.dart';

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
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.purplePrimary,
          width: 3,
        ),
        color: Colors.white,
        boxShadow: showShadow ? [
          BoxShadow(
            color: AppColors.grayDark.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 2,
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
          borderRadius: BorderRadius.circular(12),
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
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: AppTextStyle.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      counterText: '',
                      isDense: true,
                      isCollapsed: true,
                    ),
                  ),
                ),
                if (iconPath != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: AppIcons(
                      icon: iconPath!,
                      size: 20,
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