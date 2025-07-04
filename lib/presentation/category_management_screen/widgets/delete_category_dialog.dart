import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class DeleteCategoryDialog extends StatefulWidget {
  final String categoryName;
  final int instanceCount;
  final Function(bool reassignInstances) onConfirm;

  const DeleteCategoryDialog({
    Key? key,
    required this.categoryName,
    required this.instanceCount,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<DeleteCategoryDialog> createState() => _DeleteCategoryDialogState();
}

class _DeleteCategoryDialogState extends State<DeleteCategoryDialog> {
  bool _reassignInstances = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.lightTheme.dialogTheme.backgroundColor,
      shape: AppTheme.lightTheme.dialogTheme.shape,
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Delete Category',
              style: AppTheme.lightTheme.dialogTheme.titleTextStyle?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: AppTheme.lightTheme.dialogTheme.contentTextStyle,
              children: [
                TextSpan(text: 'Are you sure you want to delete the category '),
                TextSpan(
                  text: '"${widget.categoryName}"',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: '?'),
              ],
            ),
          ),
          if (widget.instanceCount > 0) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.errorContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'This category contains ${widget.instanceCount} ${widget.instanceCount == 1 ? 'instance' : 'instances'}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            Text(
              'What should happen to the instances?',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),

            // Reassign option
            RadioListTile<bool>(
              value: true,
              groupValue: _reassignInstances,
              onChanged: (value) {
                setState(() {
                  _reassignInstances = value ?? true;
                });
              },
              title: Text(
                'Move to "Uncategorized"',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                'Instances will remain but without category',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),

            // Remove option
            RadioListTile<bool>(
              value: false,
              groupValue: _reassignInstances,
              onChanged: (value) {
                setState(() {
                  _reassignInstances = value ?? false;
                });
              },
              title: Text(
                'Remove category assignment',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              subtitle: Text(
                'Instances will show without any category',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm(_reassignInstances);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            foregroundColor: AppTheme.lightTheme.colorScheme.onError,
          ),
          child: Text('Delete'),
        ),
      ],
    );
  }
}
