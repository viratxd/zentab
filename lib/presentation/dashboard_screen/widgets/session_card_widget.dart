import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SessionCardWidget extends StatelessWidget {
  final Map<String, dynamic> session;
  final bool isGridView;
  final VoidCallback onLaunch;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;

  const SessionCardWidget({
    Key? key,
    required this.session,
    required this.isGridView,
    required this.onLaunch,
    required this.onDelete,
    required this.onEdit,
    required this.onDuplicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = session['isActive'] as bool? ?? false;
    final lastAccessed = session['lastAccessed'] as DateTime?;

    return GestureDetector(
      onLongPress: () => _showQuickActions(context),
      child: Card(
        elevation: AppTheme.lightTheme.cardTheme.elevation,
        color: AppTheme.lightTheme.cardTheme.color,
        shape: AppTheme.lightTheme.cardTheme.shape,
        margin: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.all(isGridView ? 3.w : 4.w),
          child: isGridView ? _buildGridContent() : _buildListContent(),
        ),
      ),
    );
  }

  Widget _buildGridContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon and status
        Row(
          children: [
            _buildSessionIcon(size: 32),
            Spacer(),
            _buildStatusIndicator(),
            _buildOverflowMenu(),
          ],
        ),

        SizedBox(height: 2.h),

        // Session info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session['label'] as String? ?? 'Untitled',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Text(
                session['domain'] as String? ?? '',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              _buildCategoryBadge(),
              Spacer(),
              if (session['lastAccessed'] != null)
                Text(
                  _formatLastAccessed(session['lastAccessed'] as DateTime),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Launch button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onLaunch,
            style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
            child: Text('Launch'),
          ),
        ),
      ],
    );
  }

  Widget _buildListContent() {
    return Row(
      children: [
        // Session icon
        _buildSessionIcon(size: 48),

        SizedBox(width: 4.w),

        // Session info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session['label'] as String? ?? 'Untitled',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusIndicator(),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                session['domain'] as String? ?? '',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  _buildCategoryBadge(),
                  Spacer(),
                  if (session['lastAccessed'] != null)
                    Text(
                      _formatLastAccessed(session['lastAccessed'] as DateTime),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(width: 3.w),

        // Action buttons
        Column(
          children: [
            ElevatedButton(
              onPressed: onLaunch,
              style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                ),
              ),
              child: Text('Launch'),
            ),
            SizedBox(height: 1.h),
            _buildOverflowMenu(),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionIcon({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: session['icon'] != null
            ? CustomImageWidget(
                imageUrl: session['icon'] as String,
                width: size,
                height: size,
                fit: BoxFit.cover,
              )
            : Center(
                child: CustomIconWidget(
                  iconName: 'language',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: size * 0.6,
                ),
              ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final isActive = session['isActive'] as bool? ?? false;

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? AppTheme.getSuccessColor(true)
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    final category = session['category'] as String? ?? '';

    if (category.isEmpty) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOverflowMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'duplicate':
            onDuplicate();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 16,
              ),
              SizedBox(width: 12),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 16,
              ),
              SizedBox(width: 12),
              Text('Duplicate'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 16,
              ),
              SizedBox(width: 12),
              Text(
                'Delete',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
      icon: CustomIconWidget(
        iconName: 'more_vert',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: AppTheme.lightTheme.bottomSheetTheme.shape,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              session['label'] as String? ?? 'Session Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildQuickActionTile(
              icon: 'edit',
              title: 'Edit Label',
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            _buildQuickActionTile(
              icon: 'category',
              title: 'Change Category',
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            _buildQuickActionTile(
              icon: 'content_copy',
              title: 'Duplicate Instance',
              onTap: () {
                Navigator.pop(context);
                onDuplicate();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String _formatLastAccessed(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
