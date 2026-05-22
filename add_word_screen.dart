// lib/screens/add_word_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../constants/theme.dart';
import '../models/word_model.dart';
import '../providers/word_provider.dart';
import '../widgets/custom_app_bar.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({Key? key}) : super(key: key);

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _wordController;
  late TextEditingController _definitionController;
  late TextEditingController _exampleController;
  late AnimationController _containerAnimationController;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController();
    _definitionController = TextEditingController();
    _exampleController = TextEditingController();

    _containerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _containerAnimationController.forward();
  }

  @override
  void dispose() {
    _wordController.dispose();
    _definitionController.dispose();
    _exampleController.dispose();
    _containerAnimationController.dispose();
    super.dispose();
  }

  Future<void> _saveWord() async {
    if (_wordController.text.isEmpty || _definitionController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Word and definition cannot be empty';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final word = Word(
        id: const Uuid().v4(),
        word: _wordController.text.trim(),
        definition: _definitionController.text.trim(),
        example: _exampleController.text.isEmpty
          ? null
          : _exampleController.text.trim(),
        createdAt: DateTime.now(),
      );

      await context.read<WordProvider>().addWord(word);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Word added successfully!'),
            backgroundColor: AppTheme.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add New Word',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(
              parent: _containerAnimationController,
              curve: Curves.easeOut,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error Message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing12),
                    decoration: BoxDecoration(
                      color: AppTheme.warningRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(
                        color: AppTheme.warningRed.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppTheme.warningRed,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.warningRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_errorMessage != null)
                  const SizedBox(height: AppTheme.spacing20),

                // Word Input
                _buildInputSection(
                  context,
                  label: 'Word *',
                  hint: 'Enter the word',
                  controller: _wordController,
                  icon: Icons.text_fields,
                  maxLines: 1,
                ),

                const SizedBox(height: AppTheme.spacing20),

                // Definition Input
                _buildInputSection(
                  context,
                  label: 'Definition *',
                  hint: 'Enter the definition or translation',
                  controller: _definitionController,
                  icon: Icons.description_outlined,
                  maxLines: 4,
                ),

                const SizedBox(height: AppTheme.spacing20),

                // Example Input
                _buildInputSection(
                  context,
                  label: 'Example (Optional)',
                  hint: 'Enter an example sentence',
                  controller: _exampleController,
                  icon: Icons.lightbulb_outline,
                  maxLines: 2,
                ),

                const SizedBox(height: AppTheme.spacing32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveWord,
                    icon: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryBlue.withOpacity(0.3),
                            ),
                          ),
                        )
                      : const Icon(Icons.check),
                    label: Text(
                      _isLoading ? 'Saving...' : 'Save Word',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacing12),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppTheme.primaryBlue,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          minLines: maxLines == 1 ? 1 : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: AppTheme.lightBlue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: const BorderSide(
                color: AppTheme.primaryBlue,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
