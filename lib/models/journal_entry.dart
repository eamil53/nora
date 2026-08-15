import 'dart:convert';

class JournalEntry {
  final String id;
  final DateTime date;
  final int cravingLevel; // 1 (None) to 5 (Severe)
  final String mood; // 'Great', 'Calm', 'Anxious', 'Tempted', 'Stressed'
  final List<String> triggersEncountered;
  final String note;

  JournalEntry({
    required this.id,
    required this.date,
    required this.cravingLevel,
    required this.mood,
    required this.triggersEncountered,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'cravingLevel': cravingLevel,
      'mood': mood,
      'triggersEncountered': triggersEncountered,
      'note': note,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      date: DateTime.parse(map['date']),
      cravingLevel: map['cravingLevel'] ?? 1,
      mood: map['mood'] ?? 'Calm',
      triggersEncountered: List<String>.from(map['triggersEncountered'] ?? []),
      note: map['note'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory JournalEntry.fromJson(String source) => JournalEntry.fromMap(json.decode(source));
}
