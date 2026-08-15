import 'package:flutter/material.dart';
import '../../providers/app_state.dart';
import '../../models/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  final AppState appState;

  const JournalScreen({super.key, required this.appState});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  int _selectedCravingLevel = 1;
  String _selectedMood = 'Sakin';
  final List<String> _selectedTriggers = [];
  final TextEditingController _noteController = TextEditingController();

  final List<String> _moods = ['Harika', 'Sakin', 'Stresli', 'Endişeli', 'Zorlanıyor'];

  final List<String> _possibleTriggers = [
    'Stres', 'Finansal Borç', 'Sosyal Medya Reklamı', 'Gece Yalnızlık', 'Alkollü Ortam'
  ];

  void _saveEntry() {
    final newEntry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      cravingLevel: _selectedCravingLevel,
      mood: _selectedMood,
      triggersEncountered: List.from(_selectedTriggers),
      note: _noteController.text.trim(),
    );

    widget.appState.addJournalEntry(newEntry);
    _noteController.clear();
    setState(() {
      _selectedCravingLevel = 1;
      _selectedTriggers.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Günlük kaydınız kaydedildi! 💪'),
        backgroundColor: Color(0xFF00E676),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.appState.journalEntries;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        title: const Text('Günlük Duygu & Kriz Takibi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Check-in Card Form
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bugünkü İrade Check-in\'i', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Duygularınızı kaydetmek farkındalığınızı artırır.', style: TextStyle(color: Colors.white54, fontSize: 13)),
                  const SizedBox(height: 20),

                  // Craving Level Slider / Selector
                  const Text('Kumar İsteği Şiddeti (1-5):', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final level = index + 1;
                      final isSelected = _selectedCravingLevel == level;
                      return ChoiceChip(
                        label: Text('$level'),
                        selected: isSelected,
                        selectedColor: _getCravingColor(level),
                        backgroundColor: const Color(0xFF0B1120),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white60,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedCravingLevel = level);
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Mood Selector
                  const Text('Ruh Haliniz:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _moods.map((m) {
                      final isSelected = _selectedMood == m;
                      return ChoiceChip(
                        label: Text(m),
                        selected: isSelected,
                        selectedColor: const Color(0xFF6366F1),
                        backgroundColor: const Color(0xFF0B1120),
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                        onSelected: (val) {
                          if (val) setState(() => _selectedMood = m);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Triggers Checklist
                  const Text('Tetikleyiciler (Varsa):', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _possibleTriggers.map((t) {
                      final isSelected = _selectedTriggers.contains(t);
                      return FilterChip(
                        label: Text(t, style: const TextStyle(fontSize: 12)),
                        selected: isSelected,
                        selectedColor: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                        backgroundColor: const Color(0xFF0B1120),
                        labelStyle: TextStyle(color: isSelected ? const Color(0xFFF59E0B) : Colors.white60),
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedTriggers.add(t);
                            } else {
                              _selectedTriggers.remove(t);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Note Input
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Bugüne dair notlar, minnet duyguları veya düşünceler...',
                      hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF0B1120),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E676),
                        foregroundColor: const Color(0xFF0B1120),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Günlüğü Kaydet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      onPressed: _saveEntry,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Past History List
            const Text('Geçmiş Günlük Kayıtları', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (entries.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text('Henüz kaydedilmiş günlük girişi yok. İlk kaydınızı yukarıdan yapın.', style: TextStyle(color: Colors.white54, fontSize: 14)),
                ),
              )
            else
              ...entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${entry.date.day}/${entry.date.month}/${entry.date.year} • ${entry.date.hour}:${entry.date.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getCravingColor(entry.cravingLevel).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'İstek: ${entry.cravingLevel}/5',
                                style: TextStyle(color: _getCravingColor(entry.cravingLevel), fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.mood, color: Color(0xFF6366F1), size: 18),
                            const SizedBox(width: 6),
                            Text('Ruh Hali: ${entry.mood}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        if (entry.note.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(entry.note, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Color _getCravingColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF00E676);
      case 2:
        return const Color(0xFF10B981);
      case 3:
        return const Color(0xFFF59E0B);
      case 4:
        return const Color(0xFFF97316);
      default:
        return const Color(0xFFEF4444);
    }
  }
}
