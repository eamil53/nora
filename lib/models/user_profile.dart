import 'dart:convert';

class UserProfile {
  final double monthlySpend;
  final double hoursPerDay;
  final List<String> selectedAddictions;
  final List<String> selectedTriggers;
  final String mainMotivation;
  final DateTime quitDate;
  final String currencySymbol;

  UserProfile({
    required this.monthlySpend,
    required this.hoursPerDay,
    required this.selectedAddictions,
    required this.selectedTriggers,
    required this.mainMotivation,
    required this.quitDate,
    this.currencySymbol = '₺',
  });

  // Calculate total saved money based on days passed since quit date
  double calculateSavedMoney({DateTime? now}) {
    final current = now ?? DateTime.now();
    final daysPassed = current.difference(quitDate).inSeconds / (24 * 3600);
    final dailySpend = monthlySpend / 30.0;
    final saved = daysPassed * dailySpend;
    return saved < 0 ? 0 : saved;
  }

  // Calculate hours saved
  double calculateSavedHours({DateTime? now}) {
    final current = now ?? DateTime.now();
    final daysPassed = current.difference(quitDate).inSeconds / (24 * 3600);
    final saved = daysPassed * hoursPerDay;
    return saved < 0 ? 0 : saved;
  }

  // Calculate days clean
  int calculateDaysClean({DateTime? now}) {
    final current = now ?? DateTime.now();
    final difference = current.difference(quitDate).inDays;
    return difference < 0 ? 0 : difference;
  }

  // 1-Year Projected Savings
  double get yearlyProjectedSavings => monthlySpend * 12;

  Map<String, dynamic> toMap() {
    return {
      'monthlySpend': monthlySpend,
      'hoursPerDay': hoursPerDay,
      'selectedAddictions': selectedAddictions,
      'selectedTriggers': selectedTriggers,
      'mainMotivation': mainMotivation,
      'quitDate': quitDate.toIso8601String(),
      'currencySymbol': currencySymbol,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      monthlySpend: (map['monthlySpend'] as num?)?.toDouble() ?? 5000.0,
      hoursPerDay: (map['hoursPerDay'] as num?)?.toDouble() ?? 2.0,
      selectedAddictions: List<String>.from(map['selectedAddictions'] ?? ['Yasa Dışı Bahis', 'Casino & Slot']),
      selectedTriggers: List<String>.from(map['selectedTriggers'] ?? ['Stres', 'Reklamlar']),
      mainMotivation: map['mainMotivation'] ?? 'Finansal Özgürlük ve Huzur',
      quitDate: map['quitDate'] != null ? DateTime.parse(map['quitDate']) : DateTime.now(),
      currencySymbol: map['currencySymbol'] ?? '₺',
    );
  }

  String toJson() => json.encode(toMap());
  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));

  static UserProfile defaultProfile() {
    return UserProfile(
      monthlySpend: 6000.0,
      hoursPerDay: 2.5,
      selectedAddictions: ['Yasa Dışı Bahis', 'Online Casino & Slot', 'Kaldıraçlı Forex'],
      selectedTriggers: ['Finansal Stres', 'Sosyal Medya Reklamları', 'Gece Yalnızlık'],
      mainMotivation: 'Borçsuz Bir Hayat ve Aile Huzuru',
      quitDate: DateTime.now().subtract(const Duration(days: 3)),
    );
  }
}
