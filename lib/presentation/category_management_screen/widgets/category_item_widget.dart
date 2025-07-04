import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import './category_color_picker.dart';

class CategoryItemWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;
  final Function(String) onEdit;
  final VoidCallback onDelete;
  final Function(Color) onChangeColor;
  final VoidCallback onDuplicate;

  const CategoryItemWidget({
    Key? key,
    required this.category,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onChangeColor,
    required this.onDuplicate,
  }) : super(key: key);

  void _showEditDialog(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: category["name"] as String);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Category',
          style: AppTheme.lightTheme.dialogTheme.titleTextStyle,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Category Name',
            hintText: 'Enter category name',
          ),
          maxLength: 30,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != category["name"]) {
                onEdit(newName);
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryColorPicker(
        currentColor: category["color"] as Color,
        onColorSelected: (color) {
          onChangeColor(color);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: AppTheme.lightTheme.bottomSheetTheme.shape,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              category["name"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            _buildMenuOption(
              context,
              icon: 'edit',
              title: 'Rename',
              onTap: () {
                Navigator.pop(context);
                _showEditDialog(context);
              },
            ),
            _buildMenuOption(
              context,
              icon: 'palette',
              title: 'Change Color',
              onTap: () {
                Navigator.pop(context);
                _showColorPicker(context);
              },
            ),
            _buildMenuOption(
              context,
              icon: 'content_copy',
              title: 'Duplicate',
              onTap: () {
                Navigator.pop(context);
                onDuplicate();
              },
            ),
            Divider(
              color: AppTheme.lightTheme.dividerColor,
              height: 1,
            ),
            _buildMenuOption(
              context,
              icon: 'delete',
              title: 'Delete',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final instanceCount = category["instanceCount"] as int;
    final categoryColor = category["color"] as Color;
    final categoryName = category["name"] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Material(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: AppTheme.lightTheme.shadowColor,
        child: InkWell(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Drag handle
                CustomIconWidget(
                  iconName: 'drag_handle',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 3.w),

                // Color indicator
                Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),

                // Category info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '$instanceCount ${instanceCount == 1 ? 'instance' : 'instances'}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Instance count badge
                if (instanceCount > 0)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      instanceCount.toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                SizedBox(width: 2.w),

                // More options
                IconButton(
                  onPressed: () => _showContextMenu(context),
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 8.w,
                    minHeight: 8.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
