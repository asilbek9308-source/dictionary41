// lib/models/word_model.dart

class Word {
  final String id;
  final String word;
  final String definition;
  final String? example;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Word({
    required this.id,
    required this.word,
    required this.definition,
    this.example,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert Word to JSON (for storage)
  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'definition': definition,
    'example': example,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  // Create Word from JSON (from storage)
  factory Word.fromJson(Map<String, dynamic> json) => Word(
    id: json['id'] as String,
    word: json['word'] as String,
    definition: json['definition'] as String,
    example: json['example'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] != null 
      ? DateTime.parse(json['updatedAt'] as String)
      : null,
  );

  // Create a copy with modified fields
  Word copyWith({
    String? id,
    String? word,
    String? definition,
    String? example,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Word(
    id: id ?? this.id,
    word: word ?? this.word,
    definition: definition ?? this.definition,
    example: example ?? this.example,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Word &&
      runtimeType == other.runtimeType &&
      id == other.id &&
      word == other.word &&
      definition == other.definition;

  @override
  int get hashCode => id.hashCode ^ word.hashCode ^ definition.hashCode;

  @override
  String toString() => 'Word(id: $id, word: $word, definition: $definition)';
}
