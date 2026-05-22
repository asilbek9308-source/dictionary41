// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart';
import '../models/word_model.dart';
import '../providers/word_provider.dart';
import '../screens/add_word_screen.dart';
import '../screens/edit_word_screen.dart';
import '../utils/animations.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/word_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.elasticOut),
    );

    _fabAnimationController.forward();

    // Load words on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WordProvider>().loadWords();
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _navigateToAddWord() {
    Navigator.of(context).push(
      AnimationUtils.slideTransition(
        page: const AddWordScreen(),
        name: 'add_word',
      ),
    );
  }

  void _navigateToEditWord(Word word) {
    Navigator.of(context).push(
      AnimationUtils.slideTransition(
        page: EditWordScreen(word: word),
        name: 'edit_word',
      ),
    );
  }

  void _deleteWord(String wordId, BuildContext context) {
    context.read<WordProvider>().deleteWord(wordId);
    
    // Show snackbar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Word deleted'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.lightText.withOpacity(0.8),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppTheme.lightBlue,
          onPressed: () {
            // Could implement undo functionality here
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Dictionary',
        action: Consumer<WordProvider>(
          builder: (context, provider, _) {
            return Text(
              '${provider.totalWords}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            onChanged: (query) {
              // Search is handled by SearchBarWidget via provider
            },
          ),
          
          // Words List
          Expanded(
            child: Consumer<WordProvider>(
              builder: (context, wordProvider, _) {
                final words = wordProvider.words;

                if (words.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacing8,
                    horizontal: 0,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return WordCard(
                      key: ValueKey(word.id),
                      word: word,
                      index: index,
                      onEdit: () => _navigateToEditWord(word),
                      onDelete: () => _deleteWord(word.id, context),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton(
          onPressed: _navigateToAddWord,
          elevation: 4,
          tooltip: 'Add new word',
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing24),
              decoration: BoxDecoration(
                color: AppTheme.lightBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.library_books_outlined,
                size: 64,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              'No words yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              'Tap the + button to add your first word',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing32),
            ElevatedButton.icon(
              onPressed: _navigateToAddWord,
              icon: const Icon(Icons.add),
              label: const Text('Add Word'),
            ),
          ],
        ),
      ),
    );
  }
}
