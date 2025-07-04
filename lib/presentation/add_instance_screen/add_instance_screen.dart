import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_bottom_sheet_widget.dart';
import './widgets/category_selection_widget.dart';
import './widgets/icon_library_widget.dart';
import './widgets/icon_selection_widget.dart';
import './widgets/label_input_widget.dart';
import './widgets/preview_card_widget.dart';
import './widgets/url_input_widget.dart';

class AddInstanceScreen extends StatefulWidget {
  const AddInstanceScreen({Key? key}) : super(key: key);

  @override
  State<AddInstanceScreen> createState() => _AddInstanceScreenState();
}

class _AddInstanceScreenState extends State<AddInstanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _labelController = TextEditingController();
  final _scrollController = ScrollController();

  String _selectedCategory = '';
  String _selectedIconType = 'auto'; // 'auto', 'gallery', 'library'
  String _selectedIconPath = '';
  String _selectedLibraryIcon = 'web';
  bool _isUrlValid = false;
  bool _hasUnsavedChanges = false;

  // Mock categories data
  final List<String> _categories = [
    'Work',
    'Personal',
    'Social Media',
    'Entertainment',
    'Shopping',
    'Education',
    'News',
    'Finance'
  ];

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_onFormChanged);
    _labelController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _labelController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {
      _hasUnsavedChanges =
          _urlController.text.isNotEmpty || _labelController.text.isNotEmpty;
      _isUrlValid = _validateUrl(_urlController.text);
    });
  }

  bool _validateUrl(String url) {
    if (url.isEmpty) return false;

    // Add protocol if missing
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  String _getFormattedUrl() {
    String url = _urlController.text.trim();
    if (url.isEmpty) return '';

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  bool _isFormValid() {
    return _isUrlValid &&
        _labelController.text.trim().isNotEmpty &&
        _labelController.text.trim().length <= 50;
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryBottomSheetWidget(
        categories: _categories,
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) {
          setState(() {
            _selectedCategory = category;
            _hasUnsavedChanges = true;
          });
        },
        onCreateNew: (newCategory) {
          setState(() {
            _categories.add(newCategory);
            _selectedCategory = newCategory;
            _hasUnsavedChanges = true;
          });
        },
      ),
    );
  }

  void _showIconLibrary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => IconLibraryWidget(
        selectedIcon: _selectedLibraryIcon,
        onIconSelected: (iconName) {
          setState(() {
            _selectedLibraryIcon = iconName;
            _selectedIconType = 'library';
            _hasUnsavedChanges = true;
          });
        },
      ),
    );
  }

  void _selectFromGallery() {
    // Mock gallery selection
    setState(() {
      _selectedIconType = 'gallery';
      _selectedIconPath =
          'https://via.placeholder.com/60x60/2563EB/FFFFFF?text=G';
      _hasUnsavedChanges = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gallery selection simulated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unsaved Changes'),
        content:
            Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Leave'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _createInstance() {
    if (!_isFormValid()) return;

    // Mock instance creation
    final instanceData = {
      'url': _getFormattedUrl(),
      'label': _labelController.text.trim(),
      'category': _selectedCategory,
      'iconType': _selectedIconType,
      'iconPath': _selectedIconPath,
      'libraryIcon': _selectedLibraryIcon,
      'createdAt': DateTime.now().toIso8601String(),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Instance "${_labelController.text.trim()}" created successfully!'),
        backgroundColor: AppTheme.getSuccessColor(true),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate back to dashboard
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Add Instance'),
          backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
          foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
          elevation: AppTheme.lightTheme.appBarTheme.elevation,
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: _isFormValid() ? _createInstance : null,
              child: Text(
                'Save',
                style: TextStyle(
                  color: _isFormValid()
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 4.w),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // URL Input Section
                        UrlInputWidget(
                          controller: _urlController,
                          isValid: _isUrlValid,
                          onChanged: (value) => _onFormChanged(),
                        ),

                        SizedBox(height: 3.h),

                        // Label Input Section
                        LabelInputWidget(
                          controller: _labelController,
                          onChanged: (value) => _onFormChanged(),
                        ),

                        SizedBox(height: 3.h),

                        // Category Selection Section
                        CategorySelectionWidget(
                          selectedCategory: _selectedCategory,
                          onTap: _showCategoryBottomSheet,
                        ),

                        SizedBox(height: 3.h),

                        // Icon Selection Section
                        IconSelectionWidget(
                          selectedType: _selectedIconType,
                          selectedIconPath: _selectedIconPath,
                          selectedLibraryIcon: _selectedLibraryIcon,
                          onAutoFetch: () {
                            setState(() {
                              _selectedIconType = 'auto';
                              _hasUnsavedChanges = true;
                            });
                          },
                          onGallerySelect: _selectFromGallery,
                          onLibrarySelect: _showIconLibrary,
                        ),

                        SizedBox(height: 4.h),

                        // Preview Section
                        if (_labelController.text.isNotEmpty ||
                            _urlController.text.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Preview',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              PreviewCardWidget(
                                label: _labelController.text.isNotEmpty
                                    ? _labelController.text
                                    : 'Instance Label',
                                url: _getFormattedUrl().isNotEmpty
                                    ? _getFormattedUrl()
                                    : 'https://example.com',
                                category: _selectedCategory,
                                iconType: _selectedIconType,
                                iconPath: _selectedIconPath,
                                libraryIcon: _selectedLibraryIcon,
                              ),
                            ],
                          ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _isFormValid() ? _createInstance : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid()
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.12),
                      foregroundColor: _isFormValid()
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.38),
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: _isFormValid() ? 2 : 0,
                    ),
                    child: Text(
                      'Create Instance',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
