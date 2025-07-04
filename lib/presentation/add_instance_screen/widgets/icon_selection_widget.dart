import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IconSelectionWidget extends StatelessWidget {
  final String selectedType;
  final String selectedIconPath;
  final String selectedLibraryIcon;
  final VoidCallback onAutoFetch;
  final VoidCallback onGallerySelect;
  final VoidCallback onLibrarySelect;

  const IconSelectionWidget({
    Key? key,
    required this.selectedType,
    required this.selectedIconPath,
    required this.selectedLibraryIcon,
    required this.onAutoFetch,
    required this.onGallerySelect,
    required this.onLibrarySelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Icon Selection',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),

        // Auto-fetch favicon option
        _buildIconOption(
          title: 'Auto-fetch favicon',
          subtitle: 'Automatically get the website\'s icon',
          icon: 'auto_awesome',
          isSelected: selectedType == 'auto',
          onTap: onAutoFetch,
          trailing: selectedType == 'auto'
              ? Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'web',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                )
              : null,
        ),

        SizedBox(height: 1.h),

        // Gallery selection option
        _buildIconOption(
          title: 'Choose from gallery',
          subtitle: 'Select a custom image from your device',
          icon: 'photo_library',
          isSelected: selectedType == 'gallery',
          onTap: onGallerySelect,
          trailing: selectedType == 'gallery' && selectedIconPath.isNotEmpty
              ? Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CustomImageWidget(
                      imageUrl: selectedIconPath,
                      width: 10.w,
                      height: 10.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : null,
        ),

        SizedBox(height: 1.h),

        // Icon library option
        _buildIconOption(
          title: 'Select from icon library',
          subtitle: 'Choose from a collection of app icons',
          icon: 'apps',
          isSelected: selectedType == 'library',
          onTap: onLibrarySelect,
          trailing: selectedType == 'library'
              ? Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: selectedLibraryIcon,
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildIconOption({
    required String title,
    required String subtitle,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 1.5.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
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
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: 2.w),
              trailing,
            ] else if (isSelected) ...[
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
