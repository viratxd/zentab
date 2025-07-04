import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UrlInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isValid;
  final ValueChanged<String>? onChanged;

  const UrlInputWidget({
    Key? key,
    required this.controller,
    required this.isValid,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Website URL',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Enter website URL (e.g., gmail.com)',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'language',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            suffixIcon: controller.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: isValid ? 'check_circle' : 'error',
                      color: isValid
                          ? AppTheme.getSuccessColor(true)
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.error,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.5.h,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a website URL';
            }
            if (!isValid) {
              return 'Please enter a valid URL';
            }
            return null;
          },
        ),
        if (controller.text.isNotEmpty && !isValid)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 2.w),
            child: Text(
              'Please enter a valid URL (e.g., gmail.com or https://gmail.com)',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        if (controller.text.isNotEmpty && isValid)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 2.w),
            child: Text(
              'Valid URL format',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.getSuccessColor(true),
              ),
            ),
          ),
      ],
    );
  }
}
