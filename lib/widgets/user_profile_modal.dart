import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'app_modal_container.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_banner.dart';
import 'app_button.dart';
import 'app_images.dart';
import 'app_input.dart';
import 'withdraw_to_modal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileModal extends StatefulWidget {
  final VoidCallback onClose;
  final String userInitials;
  final Function(String?) onAvatarChanged;
  final String? currentAvatar;

  const UserProfileModal({
    super.key,
    required this.onClose,
    required this.userInitials,
    required this.onAvatarChanged,
    this.currentAvatar,
  });

  @override
  State<UserProfileModal> createState() => _UserProfileModalState();
}

class _UserProfileModalState extends State<UserProfileModal> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _withdrawalController = TextEditingController();
  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.currentAvatar;
  }

  // Define the input fields structure
  List<Map<String, dynamic>> get _inputFields => [
    {
      'label': 'User Name',
      'controller': _usernameController,
      'hintText': 'Enter username',
      'iconPath': AppIconData.edit,
      'readOnly': false,
    },
    {
      'label': 'Email',
      'controller': _emailController,
      'hintText': 'Enter email address',
      'keyboardType': TextInputType.emailAddress,
      'readOnly': false,
    },
    {
      'label': 'Gender',
      'controller': _genderController,
      'hintText': 'Select Gender',
      'iconPath': AppIconData.arrowDropdown,
      'readOnly': true,
      'onTap': _showGenderPicker,
      'showDropdown': true,
    },
    {
      'label': 'Age',
      'controller': _ageController,
      'hintText': 'Enter age',
      'keyboardType': TextInputType.number,
      'readOnly': false,
    },
    {
      'label': 'Withdrawal',
      'controller': _withdrawalController,
      'hintText': 'Select Account',
      'iconPath': AppIconData.arrowRight,
      'readOnly': true,
      'onTap': _showWithdrawalOptions,
    },
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _withdrawalController.dispose();
    super.dispose();
  }

  Widget _buildAvatar({bool isHeader = false}) {
    Widget avatar;
    if (_selectedAvatar != null) {
      avatar = Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isHeader ? Colors.white : AppColors.purpleLight,
            width: 2.r,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: AppImages(
            imagePath: _selectedAvatar!,
            width: 48.w,
            height: 48.h,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      avatar = Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          border: Border.all(
            color: isHeader ? Colors.white : AppColors.purpleLight,
            width: 2.r,
          ),
        ),
        child: Center(
          child: Text(
            widget.userInitials,
            style: AppTextStyle.poppins(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    if (isHeader) {
      return Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12.r,
              height: 12.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.teal,
              ),
            ),
          ),
        ],
      );
    }

    return avatar;
  }

  void _showGenderPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Male'),
              onTap: () {
                setState(() => _genderController.text = 'Male');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Female'),
              onTap: () {
                setState(() => _genderController.text = 'Female');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawalOptions() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WithdrawToModal(
        onClose: () {
          Navigator.of(context).pop();
        },
        onConfirm: (details) {
          setState(() {
            _withdrawalController.text = details['platform']!;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: AppModalContainer(
              width: double.infinity,
              height: 580.h,
              fillColor: AppColors.purplePrimary,
              borderColor: AppColors.purpleLight,
              layerColor: AppColors.purpleDark,
              borderRadius: 32.r,
              onClose: widget.onClose,
              banner: AppBanner(
                text: 'User Profile',
                fillColor: AppColors.yellowLight,
                borderColor: AppColors.yellowDark,
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'MochiyPopOne',
                ),
                width: 180.w,
                height: 35.h,
                hasShadow: true,
                shadowColor: Colors.black,
                shadowBlurRadius: 15,
              ),
              child: Stack(
                children: [
                  // User info outside white container
                  Positioned(
                    top: 18.h,
                    left: 24.w,
                    child: Row(
                      children: [
                        _buildAvatar(isHeader: true),
                        SizedBox(width: 16.w),
                        Text(
                          'John Doe',
                          style: AppTextStyle.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // White container with form
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 80.h, 16.w, 100.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ..._inputFields.map((field) => Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 70.w,
                                    child: Text(
                                      field['label'] as String,
                                      style: AppTextStyle.poppins(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 0),
                                  Expanded(
                                    child: AppInput(
                                      label: '',
                                      controller: field['controller'] as TextEditingController,
                                      hintText: field['hintText'] as String,
                                      iconPath: field['iconPath'] as String?,
                                      readOnly: field['readOnly'] as bool,
                                      onTap: field['onTap'] as VoidCallback?,
                                      keyboardType: field['keyboardType'] as TextInputType?,
                                      showDropdown: field['showDropdown'] as bool? ?? false,
                                      showShadow: true,
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                            SizedBox(height: 24.h),
                            Text(
                              'Profile Image',
                              style: AppTextStyle.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            _buildAvatarGrid(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Save button outside white container
                  Positioned(
                    left: 70.w,
                    right: 70.w,
                    bottom: 20.h,
                    child: _buildSaveButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return SizedBox(
      height: 200.h,
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.h,
        children: [
          _buildAvatar(isHeader: false),
          ...AppImageData.avatarImages.entries.map((entry) => 
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAvatar = entry.value;
                });
                widget.onAvatarChanged(_selectedAvatar);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedAvatar == entry.value 
                        ? AppColors.purpleLight 
                        : AppColors.purplePrimary,
                    width: 2.r,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: AppImages(
                    imagePath: entry.value,
                    width: 48.w,
                    height: 48.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return AppButton(
      text: 'Save',
      textStyle: AppTextStyle.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      fillColor: AppColors.greenDark,
      layerColor: AppColors.greenBright,
      height: 46.h,
      layerHeight: 40.h,
      layerTopPosition: -2.r,
      hasBorder: true,
      borderColor: Colors.white,
      borderWidth: 2.r,
      onPressed: () {
        widget.onAvatarChanged(_selectedAvatar);
        widget.onClose();
      },
    );
  }
} 