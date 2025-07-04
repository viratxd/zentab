import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _progressAnimation;

  bool _hasError = false;
  String _errorMessage = '';
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      setState(() {
        _hasError = false;
        _isInitializing = true;
      });

      // Simulate initialization tasks
      await Future.delayed(const Duration(milliseconds: 500));
      await _loadExistingWebViewInstances();

      await Future.delayed(const Duration(milliseconds: 500));
      await _prepareIsolatedStorageContexts();

      await Future.delayed(const Duration(milliseconds: 500));
      await _checkAppPermissions();

      await Future.delayed(const Duration(milliseconds: 500));
      await _initializeSessionMetadata();

      // Ensure minimum splash duration
      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        _navigateToDashboard();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to initialize app: ${e.toString()}';
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _loadExistingWebViewInstances() async {
    // Simulate loading WebView instances from local database
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - in real app, this would load from Hive/Isar
  }

  Future<void> _prepareIsolatedStorageContexts() async {
    // Simulate preparing isolated storage contexts for WebView sessions
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - in real app, this would setup WebView storage directories
  }

  Future<void> _checkAppPermissions() async {
    // Simulate checking app permissions
    await Future.delayed(const Duration(milliseconds: 200));
    // Mock implementation - in real app, this would check storage permissions
  }

  Future<void> _initializeSessionMetadata() async {
    // Simulate initializing session metadata
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - in real app, this would setup session tracking
  }

  void _navigateToDashboard() {
    Navigator.pushReplacementNamed(context, '/dashboard-screen');
  }

  void _retryInitialization() {
    _startInitialization();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppTheme.lightTheme.colorScheme.primary,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: SizedBox(
            width: 100.w,
            height: 100.h,
            child: _hasError ? _buildErrorView() : _buildSplashView(),
          ),
        ),
      ),
    );
  }

  Widget _buildSplashView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Container(),
        ),
        _buildLogoSection(),
        SizedBox(height: 8.h),
        _buildLoadingSection(),
        Expanded(
          flex: 2,
          child: Container(),
        ),
        _buildBrandingSection(),
        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(4.w),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'web',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 8.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Z',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 6.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        Text(
          'Zentab',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Multi-Session Web Management',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        if (_isInitializing) _buildProgressIndicator(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 60.w,
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                minHeight: 0.5.h,
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Initializing WebView sessions...',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBrandingSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'security',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Secure',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'tab',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Isolated',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'speed',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Fast',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 8.w,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Initialization Failed',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            _errorMessage,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: 60.w,
            child: ElevatedButton.icon(
              onPressed: _retryInitialization,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text(
                'Retry',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: () => _navigateToDashboard(),
            child: Text(
              'Continue Anyway',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
