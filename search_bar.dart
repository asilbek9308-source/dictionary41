// lib/widgets/search_bar.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../providers/word_provider.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({
    Key? key,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
      if (hasText) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }

    // Search words using provider
    context.read<WordProvider>().searchWords(_controller.text);
    widget.onChanged?.call(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    context.read<WordProvider>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
      ),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search words...',
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.lightText,
            size: 22,
          ),
          suffixIcon: AnimatedOpacity(
            opacity: _hasText ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: _hasText
              ? Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _clearSearch,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    child: const Icon(
                      Icons.close,
                      color: AppTheme.lightText,
                      size: 22,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
          hintStyle: Theme.of(context).textTheme.bodyMedium,
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
