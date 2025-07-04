import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onAddSession;

  const EmptyStateWidget({
    Key? key,
    required this.isSearching,
    required this.onAddSession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: isSearching ? 'search_off' : 'web',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              isSearching ? 'No Results Found' : 'No Sessions Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              isSearching
                  ? 'Try adjusting your search terms or filters to find what you\'re looking for.'
                  : 'Create your first WebView session to get started with isolated browsing.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action button
            if (!isSearching)
              ElevatedButton.icon(
                onPressed: onAddSession,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text('Create Your First Session'),
                style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
