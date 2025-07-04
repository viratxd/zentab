import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WebViewProgressIndicatorWidget extends StatelessWidget {
  final double progress;

  const WebViewProgressIndicatorWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.h,
      width: double.infinity,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppTheme.lightTheme.colorScheme.primary,
        ),
        minHeight: 0.5.h,
      ),
    );
  }
}
