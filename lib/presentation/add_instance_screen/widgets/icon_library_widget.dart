import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IconLibraryWidget extends StatefulWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconSelected;

  const IconLibraryWidget({
    Key? key,
    required this.selectedIcon,
    required this.onIconSelected,
  }) : super(key: key);

  @override
  State<IconLibraryWidget> createState() => _IconLibraryWidgetState();
}

class _IconLibraryWidgetState extends State<IconLibraryWidget> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _filteredIcons = [];

  // Common app icons with their names
  final List<Map<String, String>> _allIcons = [
    {'name': 'web', 'label': 'Web'},
    {'name': 'email', 'label': 'Email'},
    {'name': 'chat', 'label': 'Chat'},
    {'name': 'video_call', 'label': 'Video Call'},
    {'name': 'shopping_cart', 'label': 'Shopping'},
    {'name': 'music_note', 'label': 'Music'},
    {'name': 'movie', 'label': 'Movies'},
    {'name': 'photo', 'label': 'Photos'},
    {'name': 'camera', 'label': 'Camera'},
    {'name': 'map', 'label': 'Maps'},
    {'name': 'weather', 'label': 'Weather'},
    {'name': 'calendar_today', 'label': 'Calendar'},
    {'name': 'note', 'label': 'Notes'},
    {'name': 'book', 'label': 'Books'},
    {'name': 'newspaper', 'label': 'News'},
    {'name': 'sports', 'label': 'Sports'},
    {'name': 'fitness_center', 'label': 'Fitness'},
    {'name': 'restaurant', 'label': 'Food'},
    {'name': 'local_taxi', 'label': 'Transport'},
    {'name': 'account_balance', 'label': 'Banking'},
    {'name': 'work', 'label': 'Work'},
    {'name': 'school', 'label': 'Education'},
    {'name': 'medical_services', 'label': 'Health'},
    {'name': 'home', 'label': 'Home'},
    {'name': 'settings', 'label': 'Settings'},
    {'name': 'help', 'label': 'Help'},
    {'name': 'info', 'label': 'Info'},
    {'name': 'star', 'label': 'Favorites'},
    {'name': 'bookmark', 'label': 'Bookmarks'},
    {'name': 'download', 'label': 'Downloads'},
    {'name': 'cloud', 'label': 'Cloud'},
    {'name': 'security', 'label': 'Security'},
    {'name': 'vpn_key', 'label': 'VPN'},
    {'name': 'wifi', 'label': 'WiFi'},
    {'name': 'bluetooth', 'label': 'Bluetooth'},
    {'name': 'battery_full', 'label': 'Battery'},
    {'name': 'flash_on', 'label': 'Flash'},
    {'name': 'volume_up', 'label': 'Volume'},
    {'name': 'mic', 'label': 'Microphone'},
    {'name': 'headphones', 'label': 'Audio'},
    {'name': 'gamepad', 'label': 'Gaming'},
    {'name': 'palette', 'label': 'Design'},
    {'name': 'code', 'label': 'Code'},
    {'name': 'bug_report', 'label': 'Debug'},
    {'name': 'analytics', 'label': 'Analytics'},
    {'name': 'dashboard', 'label': 'Dashboard'},
    {'name': 'timeline', 'label': 'Timeline'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredIcons = List.from(_allIcons);
    _searchController.addListener(_filterIcons);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterIcons() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredIcons = _allIcons.where((icon) {
        return icon['name']!.toLowerCase().contains(query) ||
            icon['label']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Icon Library',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search icons...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _filterIcons();
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
              ),
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Icons grid
          Expanded(
            child: _filteredIcons.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'search_off',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No icons found',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Try searching with different keywords',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(4.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _filteredIcons.length,
                    itemBuilder: (context, index) {
                      final icon = _filteredIcons[index];
                      final isSelected = icon['name'] == widget.selectedIcon;

                      return InkWell(
                        onTap: () {
                          widget.onIconSelected(icon['name']!);
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                          .withValues(alpha: 0.1)
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: icon['name']!,
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  size: 24,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                icon['label']!,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}