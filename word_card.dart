// lib/widgets/word_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart';
import '../models/word_model.dart';

class WordCard extends StatefulWidget {
  final Word word;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int index;

  const WordCard({
    Key? key,
    required this.word,
    required this.onEdit,
    required this.onDelete,
    required this.index,
  }) : super(key: key);

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dismissible(
          key: Key(widget.word.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => widget.onDelete(),
          background: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppTheme.warningRed,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppTheme.spacing20),
            child: const Icon(
              Icons.delete_outline,
              color: AppTheme.primaryWhite,
              size: 24,
            ),
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onEdit,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                  vertical: AppTheme.spacing8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryWhite,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  boxShadow: AppTheme.softShadow,
                  border: Border.all(
                    color: AppTheme.lightBlue,
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onEdit,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    splashColor: AppTheme.lightBlue.withOpacity(0.5),
                    highlightColor: AppTheme.lightBlue.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Word
                          Text(
                            widget.word.word,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppTheme.spacing8),

                          // Definition
                          Text(
                            widget.word.definition,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Example (if available)
                          if (widget.word.example != null &&
                              widget.word.example!.isNotEmpty) ...[
                            const SizedBox(height: AppTheme.spacing8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing12,
                                vertical: AppTheme.spacing8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.lightBlue,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusSmall,
                                ),
                              ),
                              child: Text(
                                '"${widget.word.example}"',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppTheme.darkText,
                                      fontStyle: FontStyle.italic,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],

                          // Date
                          const SizedBox(height: AppTheme.spacing12),
                          Text(
                            _formatDate(widget.word.createdAt),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppTheme.lightText,
                                ),
                          ),

                          // Edit Button
                          const SizedBox(height: AppTheme.spacing12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: widget.onEdit,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusSmall,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    AppTheme.spacing4,
                                  ),
                                  child: Text(
                                    'Edit',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
