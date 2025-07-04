import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class WebViewBottomToolbarWidget extends StatelessWidget {
  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onBackPressed;
  final VoidCallback onForwardPressed;
  final VoidCallback onReloadPressed;
  final VoidCallback onClosePressed;

  const WebViewBottomToolbarWidget({
    super.key,
    required this.canGoBack,
    required this.canGoForward,
    required this.onBackPressed,
    required this.onForwardPressed,
    required this.onReloadPressed,
    required this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            offset: Offset(0, -1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Back Button
              _buildToolbarButton(
                iconName: 'arrow_back',
                onPressed: canGoBack ? onBackPressed : null,
                isEnabled: canGoBack,
              ),

              // Forward Button
              _buildToolbarButton(
                iconName: 'arrow_forward',
                onPressed: canGoForward ? onForwardPressed : null,
                isEnabled: canGoForward,
              ),

              // Reload Button
              _buildToolbarButton(
                iconName: 'refresh',
                onPressed: onReloadPressed,
                isEnabled: true,
              ),

              // Close Button
              _buildToolbarButton(
                iconName: 'close',
                onPressed: onClosePressed,
                isEnabled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required String iconName,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: isEnabled
              ? Colors.transparent
              : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: isEnabled
                ? AppTheme.lightTheme.colorScheme.onSurface
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.4),
            size: 6.w,
          ),
        ),
      ),
    );
  }
}
