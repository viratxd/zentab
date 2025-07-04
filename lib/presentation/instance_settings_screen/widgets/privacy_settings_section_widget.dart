import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PrivacySettingsSectionWidget extends StatelessWidget {
  final bool clearCookiesOnExit;
  final bool blockThirdPartyCookies;
  final bool enableJavaScript;
  final bool allowLocationAccess;
  final Function(String, bool) onChanged;

  const PrivacySettingsSectionWidget({
    Key? key,
    required this.clearCookiesOnExit,
    required this.blockThirdPartyCookies,
    required this.enableJavaScript,
    required this.allowLocationAccess,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.getSessionCardDecoration(isLight: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Settings',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildToggleItem(
            context: context,
            title: 'Clear Cookies on Exit',
            subtitle:
                'Automatically clear all cookies when closing this instance',
            value: clearCookiesOnExit,
            onChanged: (value) => onChanged('clearCookiesOnExit', value),
            icon: 'delete_outline',
          ),
          _buildToggleItem(
            context: context,
            title: 'Block Third-party Cookies',
            subtitle: 'Prevent websites from setting tracking cookies',
            value: blockThirdPartyCookies,
            onChanged: (value) => onChanged('blockThirdPartyCookies', value),
            icon: 'block',
          ),
          _buildToggleItem(
            context: context,
            title: 'Enable JavaScript',
            subtitle: 'Allow websites to run JavaScript code',
            value: enableJavaScript,
            onChanged: (value) => onChanged('enableJavaScript', value),
            icon: 'code',
          ),
          _buildToggleItem(
            context: context,
            title: 'Allow Location Access',
            subtitle: 'Let websites request your location',
            value: allowLocationAccess,
            onChanged: (value) => onChanged('allowLocationAccess', value),
            icon: 'location_on',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required String icon,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 2.h),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            height: 1,
          ),
          SizedBox(height: 2.h),
        ],
      ],
    );
  }
}
