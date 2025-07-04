import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class WebViewAppBarWidget extends StatelessWidget {
  final String instanceLabel;
  final String domain;
  final VoidCallback onBackPressed;
  final VoidCallback onReloadPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onClearCachePressed;

  const WebViewAppBarWidget({
    super.key,
    required this.instanceLabel,
    required this.domain,
    required this.onBackPressed,
    required this.onReloadPressed,
    required this.onSharePressed,
    required this.onBookmarkPressed,
    required this.onClearCachePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.appBarTheme.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: onBackPressed,
              child: Container(
                width: 10.w,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Instance Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    instanceLabel,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.2.h),
                  Text(
                    domain,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Reload Button
            GestureDetector(
              onTap: onReloadPressed,
              child: Container(
                width: 10.w,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ),
            ),

            SizedBox(width: 2.w),

            // More Options Menu
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'share':
                    onSharePressed();
                    break;
                  case 'bookmark':
                    onBookmarkPressed();
                    break;
                  case 'clear_cache':
                    onClearCachePressed();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Share URL',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'bookmark',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'bookmark_add',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Add Bookmark',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'clear_cache',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'clear_all',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Clear Cache',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
              child: Container(
                width: 10.w,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
