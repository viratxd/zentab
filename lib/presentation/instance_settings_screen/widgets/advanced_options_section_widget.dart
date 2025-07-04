import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedOptionsSectionWidget extends StatelessWidget {
  final String selectedUserAgent;
  final List<String> userAgents;
  final double zoomLevel;
  final TextEditingController homepageController;
  final Function(String) onUserAgentChanged;
  final Function(double) onZoomChanged;
  final VoidCallback onHomepageChanged;

  const AdvancedOptionsSectionWidget({
    Key? key,
    required this.selectedUserAgent,
    required this.userAgents,
    required this.zoomLevel,
    required this.homepageController,
    required this.onUserAgentChanged,
    required this.onZoomChanged,
    required this.onHomepageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: AppTheme.getSessionCardDecoration(isLight: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Options',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildUserAgentSelector(context),
          SizedBox(height: 3.h),
          _buildZoomLevelSlider(context),
          SizedBox(height: 3.h),
          _buildHomepageField(),
        ],
      ),
    );
  }

  Widget _buildUserAgentSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'computer',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Agent',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'How this instance identifies itself to websites',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: selectedUserAgent,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: userAgents
              .map((agent) => DropdownMenuItem(
                    value: agent,
                    child: Text(agent),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onUserAgentChanged(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildZoomLevelSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'zoom_in',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zoom Level',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Default zoom level for web pages',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${zoomLevel.round()}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: zoomLevel,
            min: 50,
            max: 200,
            divisions: 15,
            onChanged: onZoomChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildHomepageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Homepage URL Override',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Custom homepage to load when opening this instance',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: homepageController,
          decoration: InputDecoration(
            hintText: 'Leave empty to use default URL',
            prefixIcon: Icon(Icons.link),
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final uri = Uri.tryParse(value);
              if (uri == null || !uri.hasAbsolutePath) {
                return 'Please enter a valid URL';
              }
            }
            return null;
          },
          onChanged: (_) => onHomepageChanged(),
        ),
      ],
    );
  }
}