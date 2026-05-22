// lib/providers/word_provider.dart

import 'package:flutter/material.dart';
import '../models/word_model.dart';
import '../services/storage_service.dart';

class WordProvider extends ChangeNotifier {
  List<Word> _words = [];
  List<Word> _filteredWords = [];
  String _searchQuery = '';

  List<Word> get words => _filteredWords.isEmpty && _searchQuery.isEmpty 
    ? _words 
    : _filteredWords;
  
  String get searchQuery => _searchQuery;
  int get totalWords => _words.length;

  // Initialize provider by loading all words
  Future<void> loadWords() async {
    _words = StorageService.getAllWords();
    _filteredWords = _words;
    notifyListeners();
  }

  // Add a new word
  Future<void> addWord(Word word) async {
    await StorageService.addWord(word);
    _words.add(word);
    _words.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _updateFilteredWords();
    notifyListeners();
  }

  // Update an existing word
  Future<void> updateWord(Word word) async {
    await StorageService.updateWord(word);
    final index = _words.indexWhere((w) => w.id == word.id);
    if (index != -1) {
      _words[index] = word;
      _updateFilteredWords();
      notifyListeners();
    }
  }

  // Delete a word
  Future<void> deleteWord(String id) async {
    await StorageService.deleteWord(id);
    _words.removeWhere((w) => w.id == id);
    _updateFilteredWords();
    notifyListeners();
  }

  // Search words
  void searchWords(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredWords = _words;
    } else {
      _filteredWords = StorageService.searchWords(query);
    }
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredWords = _words;
    notifyListeners();
  }

  // Update filtered words based on current search
  void _updateFilteredWords() {
    if (_searchQuery.isEmpty) {
      _filteredWords = _words;
    } else {
      _filteredWords = StorageService.searchWords(_searchQuery);
    }
  }

  // Get a word by ID
  Word? getWordById(String id) {
    try {
      return _words.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }
}
