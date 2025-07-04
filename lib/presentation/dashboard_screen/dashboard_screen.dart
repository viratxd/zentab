import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_filter_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/session_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isGridView = true;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Mock data for WebView sessions
  final List<Map<String, dynamic>> _sessions = [
    {
      "id": "1",
      "label": "Work Gmail",
      "url": "https://mail.google.com",
      "domain": "mail.google.com",
      "category": "Work",
      "icon": "https://ssl.gstatic.com/ui/v1/icons/mail/rfr/gmail.ico",
      "lastAccessed": DateTime.now().subtract(Duration(hours: 2)),
      "isActive": true,
    },
    {
      "id": "2",
      "label": "Personal Facebook",
      "url": "https://facebook.com",
      "domain": "facebook.com",
      "category": "Social",
      "icon": "https://static.xx.fbcdn.net/rsrc.php/yo/r/iRmz9lCMBD2.ico",
      "lastAccessed": DateTime.now().subtract(Duration(days: 1)),
      "isActive": false,
    },
    {
      "id": "3",
      "label": "ChatGPT Plus",
      "url": "https://chat.openai.com",
      "domain": "chat.openai.com",
      "category": "AI Tools",
      "icon": "https://chat.openai.com/favicon.ico",
      "lastAccessed": DateTime.now().subtract(Duration(minutes: 30)),
      "isActive": true,
    },
    {
      "id": "4",
      "label": "WhatsApp Business",
      "url": "https://web.whatsapp.com",
      "domain": "web.whatsapp.com",
      "category": "Work",
      "icon": "https://static.whatsapp.net/rsrc.php/v3/yP/r/rYZqPCBaG70.png",
      "lastAccessed": DateTime.now().subtract(Duration(hours: 5)),
      "isActive": false,
    },
    {
      "id": "5",
      "label": "Twitter Marketing",
      "url": "https://twitter.com",
      "domain": "twitter.com",
      "category": "Social",
      "icon": "https://abs.twimg.com/favicons/twitter.2.ico",
      "lastAccessed": DateTime.now().subtract(Duration(hours: 8)),
      "isActive": true,
    },
    {
      "id": "6",
      "label": "GitHub Projects",
      "url": "https://github.com",
      "domain": "github.com",
      "category": "Development",
      "icon": "https://github.githubassets.com/favicons/favicon.svg",
      "lastAccessed": DateTime.now().subtract(Duration(days: 2)),
      "isActive": false,
    },
  ];

  List<String> get _categories {
    final categories = _sessions
        .map((session) => session['category'] as String)
        .toSet()
        .toList();
    categories.insert(0, 'All');
    return categories;
  }

  List<Map<String, dynamic>> get _filteredSessions {
    return _sessions.where((session) {
      final matchesCategory = _selectedCategory == 'All' ||
          session['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          (session['label'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (session['domain'] as String)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _launchSession(Map<String, dynamic> session) {
    Navigator.pushNamed(
      context,
      '/web-view-screen',
      arguments: session,
    );
  }

  void _deleteSession(String sessionId) {
    setState(() {
      _sessions.removeWhere((session) => session['id'] == sessionId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _editSession(Map<String, dynamic> session) {
    Navigator.pushNamed(
      context,
      '/instance-settings-screen',
      arguments: session,
    );
  }

  void _duplicateSession(Map<String, dynamic> session) {
    final newSession = Map<String, dynamic>.from(session);
    newSession['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    newSession['label'] = '${session['label']} Copy';

    setState(() {
      _sessions.add(newSession);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Session duplicated')),
    );
  }

  Future<void> _refreshSessions() async {
    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 1));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sessions refreshed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search sessions...',
                  border: InputBorder.none,
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              )
            : Text(
                'Zentab',
                style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
              ),
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _isSearching ? 'close' : 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _toggleView,
            icon: CustomIconWidget(
              iconName: _isGridView ? 'view_list' : 'grid_view',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'categories') {
                Navigator.pushNamed(context, '/category-management-screen');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'categories',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'category',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text('Manage Categories'),
                  ],
                ),
              ),
            ],
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSessions,
        child: Column(
          children: [
            // Category Filter
            if (!_isSearching)
              CategoryFilterWidget(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),

            // Sessions List/Grid
            Expanded(
              child: _filteredSessions.isEmpty
                  ? EmptyStateWidget(
                      isSearching: _searchQuery.isNotEmpty,
                      onAddSession: () {
                        Navigator.pushNamed(context, '/add-instance-screen');
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: _isGridView ? _buildGridView() : _buildListView(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-instance-screen');
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 100.w > 600 ? 3 : 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.85,
      ),
      itemCount: _filteredSessions.length,
      itemBuilder: (context, index) {
        final session = _filteredSessions[index];
        return SessionCardWidget(
          session: session,
          isGridView: true,
          onLaunch: () => _launchSession(session),
          onDelete: () => _deleteSession(session['id']),
          onEdit: () => _editSession(session),
          onDuplicate: () => _duplicateSession(session),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
      itemCount: _filteredSessions.length,
      itemBuilder: (context, index) {
        final session = _filteredSessions[index];
        return Dismissible(
          key: Key(session['id']),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.lightTheme.colorScheme.onError,
              size: 24,
            ),
          ),
          onDismissed: (direction) {
            _deleteSession(session['id']);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: SessionCardWidget(
              session: session,
              isGridView: false,
              onLaunch: () => _launchSession(session),
              onDelete: () => _deleteSession(session['id']),
              onEdit: () => _editSession(session),
              onDuplicate: () => _duplicateSession(session),
            ),
          ),
        );
      },
    );
  }
}
