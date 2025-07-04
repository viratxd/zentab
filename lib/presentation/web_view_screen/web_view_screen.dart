import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/app_theme.dart';
import './widgets/web_view_app_bar_widget.dart';
import './widgets/web_view_bottom_toolbar_widget.dart';
import './widgets/web_view_progress_indicator_widget.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _canGoBack = false;
  bool _canGoForward = false;
  String _currentUrl = '';
  String _pageTitle = '';
  double _loadingProgress = 0.0;

  // Mock instance data - in real app this would come from arguments
  final Map<String, dynamic> _instanceData = {
    'id': '1',
    'label': 'Gmail Work',
    'url': 'https://mail.google.com',
    'domain': 'mail.google.com',
    'category': 'Work',
    'icon': 'https://ssl.gstatic.com/ui/v1/icons/mail/rfr/gmail.ico',
  };

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.lightTheme.scaffoldBackgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100.0;
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _currentUrl = url;
              _isLoading = true;
            });
            _updateNavigationState();
          },
          onPageFinished: (String url) {
            setState(() {
              _currentUrl = url;
              _isLoading = false;
            });
            _updateNavigationState();
            _getPageTitle();
          },
          onWebResourceError: (WebResourceError error) {
            _showErrorDialog(error.description);
          },
        ),
      )
      ..loadRequest(Uri.parse(_instanceData['url']));
  }

  void _updateNavigationState() async {
    final canGoBack = await _webViewController.canGoBack();
    final canGoForward = await _webViewController.canGoForward();
    setState(() {
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }

  void _getPageTitle() async {
    final title = await _webViewController.getTitle();
    setState(() {
      _pageTitle = title ?? '';
    });
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Connection Error',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Failed to load page: $error',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _webViewController.reload();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _shareUrl() {
    HapticFeedback.lightImpact();
    // In real app, would use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality would be implemented here'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addBookmark() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmark added successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearCache() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Cache',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'This will clear all cached data for this session. Continue?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _webViewController.clearCache();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cache cleared successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _goBack() {
    HapticFeedback.lightImpact();
    if (_canGoBack) {
      _webViewController.goBack();
    }
  }

  void _goForward() {
    HapticFeedback.lightImpact();
    if (_canGoForward) {
      _webViewController.goForward();
    }
  }

  void _reload() {
    HapticFeedback.lightImpact();
    _webViewController.reload();
  }

  void _close() {
    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_canGoBack) {
          _webViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              WebViewAppBarWidget(
                instanceLabel: _instanceData['label'],
                domain: _instanceData['domain'],
                onBackPressed: _close,
                onReloadPressed: _reload,
                onSharePressed: _shareUrl,
                onBookmarkPressed: _addBookmark,
                onClearCachePressed: _clearCache,
              ),

              // Progress Indicator
              if (_isLoading)
                WebViewProgressIndicatorWidget(
                  progress: _loadingProgress,
                ),

              // WebView
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _webViewController.reload();
                  },
                  child: WebViewWidget(
                    controller: _webViewController,
                  ),
                ),
              ),

              // Bottom Toolbar
              WebViewBottomToolbarWidget(
                canGoBack: _canGoBack,
                canGoForward: _canGoForward,
                onBackPressed: _goBack,
                onForwardPressed: _goForward,
                onReloadPressed: _reload,
                onClosePressed: _close,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
