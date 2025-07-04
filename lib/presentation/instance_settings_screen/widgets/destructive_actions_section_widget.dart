import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DestructiveActionsSectionWidget extends StatelessWidget {
  final VoidCallback onClearAllData;
  final VoidCallback onResetToDefaults;

  const DestructiveActionsSectionWidget({
    Key? key,
    required this.onClearAllData,
    required this.onResetToDefaults,
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
            'Destructive Actions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            context: context,
            title: 'Clear All Data',
            subtitle: 'Remove all cookies, cache, and stored data',
            icon: 'delete_forever',
            onTap: onClearAllData,
            isDestructive: true,
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            context: context,
            title: 'Reset to Defaults',
            subtitle: 'Restore all settings to their default values',
            icon: 'restore',
            onTap: onResetToDefaults,
            isDestructive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
    required bool isDestructive,
  }) {
    final Color iconColor = isDestructive
        ? AppTheme.lightTheme.colorScheme.error
        : AppTheme.lightTheme.colorScheme.onSurfaceVariant;

    final Color textColor = isDestructive
        ? AppTheme.lightTheme.colorScheme.error
        : AppTheme.lightTheme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDestructive
                ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: iconColor,
              size: 24,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: textColor,
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
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
