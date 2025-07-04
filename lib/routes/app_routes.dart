import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/web_view_screen/web_view_screen.dart';
import '../presentation/instance_settings_screen/instance_settings_screen.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/category_management_screen/category_management_screen.dart';
import '../presentation/add_instance_screen/add_instance_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String webViewScreen = '/web-view-screen';
  static const String instanceSettingsScreen = '/instance-settings-screen';
  static const String dashboardScreen = '/dashboard-screen';
  static const String categoryManagementScreen = '/category-management-screen';
  static const String addInstanceScreen = '/add-instance-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    webViewScreen: (context) => const WebViewScreen(),
    instanceSettingsScreen: (context) => const InstanceSettingsScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    categoryManagementScreen: (context) => const CategoryManagementScreen(),
    addInstanceScreen: (context) => const AddInstanceScreen(),
    // TODO: Add your other routes here
  };
}
