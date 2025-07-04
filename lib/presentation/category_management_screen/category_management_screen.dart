import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_category_bottom_sheet.dart';
import './widgets/category_item_widget.dart';
import './widgets/delete_category_dialog.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadMockCategories();
    _filteredCategories = List.from(_categories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadMockCategories() {
    _categories = [
      {
        "id": "1",
        "name": "Work",
        "color": AppTheme.lightTheme.colorScheme.primary,
        "instanceCount": 5,
        "createdAt": DateTime.now().subtract(Duration(days: 30)),
      },
      {
        "id": "2",
        "name": "Social Media",
        "color": AppTheme.lightTheme.colorScheme.tertiary,
        "instanceCount": 8,
        "createdAt": DateTime.now().subtract(Duration(days: 15)),
      },
      {
        "id": "3",
        "name": "Personal",
        "color": AppTheme.lightTheme.colorScheme.secondary,
        "instanceCount": 3,
        "createdAt": DateTime.now().subtract(Duration(days: 7)),
      },
      {
        "id": "4",
        "name": "Development",
        "color": Color(0xFF9C27B0),
        "instanceCount": 12,
        "createdAt": DateTime.now().subtract(Duration(days: 45)),
      },
      {
        "id": "5",
        "name": "Shopping",
        "color": Color(0xFFFF9800),
        "instanceCount": 2,
        "createdAt": DateTime.now().subtract(Duration(days: 3)),
      },
    ];
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = List.from(_categories);
      } else {
        _filteredCategories = _categories
            .where((category) => (category["name"] as String)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showAddCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCategoryBottomSheet(
        onCategoryAdded: _addCategory,
      ),
    );
  }

  void _addCategory(String name, Color color) {
    final newCategory = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "name": name,
      "color": color,
      "instanceCount": 0,
      "createdAt": DateTime.now(),
    };

    setState(() {
      _categories.add(newCategory);
      _filterCategories(_searchController.text);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category "$name" created successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _editCategory(String categoryId, String newName) {
    setState(() {
      final index = _categories.indexWhere((cat) => cat["id"] == categoryId);
      if (index != -1) {
        _categories[index]["name"] = newName;
        _filterCategories(_searchController.text);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category renamed to "$newName"'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _changeColor(String categoryId, Color newColor) {
    setState(() {
      final index = _categories.indexWhere((cat) => cat["id"] == categoryId);
      if (index != -1) {
        _categories[index]["color"] = newColor;
        _filterCategories(_searchController.text);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category color updated'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _deleteCategory(String categoryId) {
    final category = _categories.firstWhere((cat) => cat["id"] == categoryId);
    final instanceCount = category["instanceCount"] as int;

    showDialog(
      context: context,
      builder: (context) => DeleteCategoryDialog(
        categoryName: category["name"] as String,
        instanceCount: instanceCount,
        onConfirm: (reassignInstances) {
          setState(() {
            _categories.removeWhere((cat) => cat["id"] == categoryId);
            _filterCategories(_searchController.text);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(instanceCount > 0
                  ? reassignInstances
                      ? 'Category deleted and instances reassigned'
                      : 'Category deleted and instances uncategorized'
                  : 'Category deleted successfully'),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            ),
          );
        },
      ),
    );
  }

  void _duplicateCategory(String categoryId) {
    final originalCategory =
        _categories.firstWhere((cat) => cat["id"] == categoryId);
    final duplicatedCategory = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "name": "${originalCategory["name"]} Copy",
      "color": originalCategory["color"],
      "instanceCount": 0,
      "createdAt": DateTime.now(),
    };

    setState(() {
      _categories.add(duplicatedCategory);
      _filterCategories(_searchController.text);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category duplicated successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _navigateToCategoryView(String categoryId) {
    Navigator.pushNamed(context, '/dashboard-screen',
        arguments: {'categoryFilter': categoryId});
  }

  void _reorderCategories(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _filteredCategories.removeAt(oldIndex);
      _filteredCategories.insert(newIndex, item);

      // Update the main categories list
      _categories = List.from(_filteredCategories);
    });

    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  border: InputBorder.none,
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                onChanged: _filterCategories,
              )
            : Text(
                'Categories',
                style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
              ),
        actions: [
          if (_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _filterCategories('');
                });
              },
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            )
          else ...[
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _showAddCategoryBottomSheet,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ],
          SizedBox(width: 2.w),
        ],
      ),
      body: _filteredCategories.isEmpty
          ? _buildEmptyState()
          : _buildCategoryList(),
      floatingActionButton: _isSearching
          ? null
          : FloatingActionButton(
              onPressed: _showAddCategoryBottomSheet,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'folder_open',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No categories found'
                  : 'No categories yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : 'Create categories to organize your WebView instances and keep everything tidy',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchController.text.isEmpty) ...[
              SizedBox(height: 4.h),
              ElevatedButton.icon(
                onPressed: _showAddCategoryBottomSheet,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 18,
                ),
                label: Text('Create Category'),
                style: AppTheme.lightTheme.elevatedButtonTheme.style,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return ReorderableListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: _filteredCategories.length,
      onReorder: _reorderCategories,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        return CategoryItemWidget(
          key: ValueKey(category["id"]),
          category: category,
          onTap: () => _navigateToCategoryView(category["id"] as String),
          onEdit: (newName) => _editCategory(category["id"] as String, newName),
          onDelete: () => _deleteCategory(category["id"] as String),
          onChangeColor: (newColor) =>
              _changeColor(category["id"] as String, newColor),
          onDuplicate: () => _duplicateCategory(category["id"] as String),
        );
      },
    );
  }
}
