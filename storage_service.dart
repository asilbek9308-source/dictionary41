// lib/services/storage_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../models/word_model.dart';

class StorageService {
  static const String _boxName = 'words';
  static late Box<Map> _wordsBox;

  // Initialize Hive and open box
  static Future<void> init() async {
    await Hive.initFlutter();
    _wordsBox = await Hive.openBox<Map>(_boxName);
  }

  // Add a new word
  static Future<void> addWord(Word word) async {
    await _wordsBox.put(word.id, word.toJson());
  }

  // Get all words
  static List<Word> getAllWords() {
    try {
      return _wordsBox.values
        .map((map) => Word.fromJson(Map<String, dynamic>.from(map)))
        .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error reading words: $e');
      return [];
    }
  }

  // Get a specific word by ID
  static Word? getWordById(String id) {
    try {
      final data = _wordsBox.get(id);
      if (data != null) {
        return Word.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      print('Error getting word: $e');
      return null;
    }
  }

  // Update a word
  static Future<void> updateWord(Word word) async {
    await _wordsBox.put(word.id, word.toJson());
  }

  // Delete a word by ID
  static Future<void> deleteWord(String id) async {
    await _wordsBox.delete(id);
  }

  // Search words by keyword (searches both word and definition)
  static List<Word> searchWords(String query) {
    try {
      final lowerQuery = query.toLowerCase();
      return _wordsBox.values
        .map((map) => Word.fromJson(Map<String, dynamic>.from(map)))
        .where((word) =>
          word.word.toLowerCase().contains(lowerQuery) ||
          word.definition.toLowerCase().contains(lowerQuery))
        .toList()
        ..sort((a, b) => a.word.compareTo(b.word));
    } catch (e) {
      print('Error searching words: $e');
      return [];
    }
  }

  // Clear all words (use with caution!)
  static Future<void> clearAllWords() async {
    await _wordsBox.clear();
  }

  // Get total count of words
  static int getWordCount() {
    return _wordsBox.length;
  }

  // Close the box (call when app closes)
  static Future<void> close() async {
    await _wordsBox.close();
  }
}
