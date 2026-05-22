// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import '../constants/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? action;
  final double elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.action,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          letterSpacing: 0.5,
        ),
      ),
      leading: showBackButton
        ? Padding(
            padding: const EdgeInsets.all(AppTheme.spacing8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBackPressed ?? () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                child: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
            ),
          )
        : null,
      actions: action != null ? [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
          ),
          child: action,
        ),
      ] : null,
      elevation: elevation,
      scrolledUnderElevation: 0.5,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
