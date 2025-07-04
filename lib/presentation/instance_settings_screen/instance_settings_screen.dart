import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_options_section_widget.dart';
import './widgets/basic_info_section_widget.dart';
import './widgets/destructive_actions_section_widget.dart';
import './widgets/privacy_settings_section_widget.dart';

class InstanceSettingsScreen extends StatefulWidget {
  const InstanceSettingsScreen({Key? key}) : super(key: key);

  @override
  State<InstanceSettingsScreen> createState() => _InstanceSettingsScreenState();
}

class _InstanceSettingsScreenState extends State<InstanceSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _homepageController = TextEditingController();

  bool _hasUnsavedChanges = false;
  bool _isSaving = false;

  // Mock instance data
  final Map<String, dynamic> _instanceData = {
    "id": "inst_001",
    "label": "Gmail Work",
    "url": "https://mail.google.com",
    "category": "Work",
    "iconUrl": "https://ssl.gstatic.com/ui/v1/icons/mail/rfr/gmail.ico",
    "clearCookiesOnExit": false,
    "blockThirdPartyCookies": true,
    "enableJavaScript": true,
    "allowLocationAccess": false,
    "userAgent": "Default",
    "zoomLevel": 100.0,
    "homepageUrl": "",
  };

  final List<String> _categories = [
    "Work",
    "Personal",
    "Social Media",
    "Entertainment",
    "Shopping",
    "Education",
    "Finance",
    "Other"
  ];

  final List<String> _userAgents = [
    "Default",
    "Chrome Desktop",
    "Safari Desktop",
    "Firefox Desktop",
    "Chrome Mobile",
    "Safari Mobile"
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _labelController.text = _instanceData["label"] as String;
    _urlController.text = _instanceData["url"] as String;
    _homepageController.text = _instanceData["homepageUrl"] as String;
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    // Simulate save operation
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _isSaving = false;
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings saved successfully'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Unsaved Changes'),
            content: Text(
                'You have unsaved changes. Do you want to save them before leaving?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Discard'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(false);
                  await _saveChanges();
                  Navigator.of(context).pop();
                },
                child: Text('Save & Exit'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            _instanceData["label"] as String,
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            if (_hasUnsavedChanges)
              _isSaving
                  ? Container(
                      width: 24,
                      height: 24,
                      margin: EdgeInsets.only(right: 4.w),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: _saveChanges,
                      icon: CustomIconWidget(
                        iconName: 'save',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicInfoSectionWidget(
                  labelController: _labelController,
                  urlController: _urlController,
                  selectedCategory: _instanceData["category"] as String,
                  categories: _categories,
                  iconUrl: _instanceData["iconUrl"] as String,
                  onChanged: _onFieldChanged,
                ),
                SizedBox(height: 3.h),
                PrivacySettingsSectionWidget(
                  clearCookiesOnExit:
                      _instanceData["clearCookiesOnExit"] as bool,
                  blockThirdPartyCookies:
                      _instanceData["blockThirdPartyCookies"] as bool,
                  enableJavaScript: _instanceData["enableJavaScript"] as bool,
                  allowLocationAccess:
                      _instanceData["allowLocationAccess"] as bool,
                  onChanged: (key, value) {
                    setState(() {
                      _instanceData[key] = value;
                    });
                    _onFieldChanged();
                  },
                ),
                SizedBox(height: 3.h),
                AdvancedOptionsSectionWidget(
                  selectedUserAgent: _instanceData["userAgent"] as String,
                  userAgents: _userAgents,
                  zoomLevel: _instanceData["zoomLevel"] as double,
                  homepageController: _homepageController,
                  onUserAgentChanged: (value) {
                    setState(() {
                      _instanceData["userAgent"] = value;
                    });
                    _onFieldChanged();
                  },
                  onZoomChanged: (value) {
                    setState(() {
                      _instanceData["zoomLevel"] = value;
                    });
                    _onFieldChanged();
                  },
                  onHomepageChanged: _onFieldChanged,
                ),
                SizedBox(height: 3.h),
                DestructiveActionsSectionWidget(
                  onClearAllData: () => _showClearDataDialog(),
                  onResetToDefaults: () => _showResetDialog(),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Data'),
        content: Text(
          'This will permanently delete all cookies, cache, and stored data for this instance. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset to Defaults'),
        content: Text(
          'This will reset all settings to their default values. Your custom label and URL will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetToDefaults();
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _clearAllData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All data cleared successfully'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _instanceData["clearCookiesOnExit"] = false;
      _instanceData["blockThirdPartyCookies"] = true;
      _instanceData["enableJavaScript"] = true;
      _instanceData["allowLocationAccess"] = false;
      _instanceData["userAgent"] = "Default";
      _instanceData["zoomLevel"] = 100.0;
      _instanceData["homepageUrl"] = "";
      _homepageController.text = "";
      _hasUnsavedChanges = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings reset to defaults'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    _urlController.dispose();
    _homepageController.dispose();
    super.dispose();
  }
}
