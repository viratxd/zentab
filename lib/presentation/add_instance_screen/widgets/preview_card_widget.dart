import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PreviewCardWidget extends StatelessWidget {
  final String label;
  final String url;
  final String category;
  final String iconType;
  final String iconPath;
  final String libraryIcon;

  const PreviewCardWidget({
    Key? key,
    required this.label,
    required this.url,
    required this.category,
    required this.iconType,
    required this.iconPath,
    required this.libraryIcon,
  }) : super(key: key);

  String _getDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host.replaceFirst('www.', '');
    } catch (e) {
      return url;
    }
  }

  Widget _buildIcon() {
    switch (iconType) {
      case 'gallery':
        if (iconPath.isNotEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: iconPath,
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
          );
        }
        break;
      case 'library':
        return Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: libraryIcon,
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
        );
      case 'auto':
      default:
        return Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: 'web',
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
        );
    }

    // Fallback icon
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomIconWidget(
        iconName: 'web',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          _buildIcon(),

          SizedBox(width: 3.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 0.5.h),

                // Domain
                Text(
                  _getDomainFromUrl(url),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Category chip
                if (category.isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      category,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          Column(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: 'launch',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: 'delete',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
