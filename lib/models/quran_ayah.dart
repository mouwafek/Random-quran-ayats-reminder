class QuranAyah {
  final String arabic;
  final String translation;
  final String surah;
  final String englishName;
  final String number;

  QuranAyah({
    required this.arabic,
    required this.translation,
    required this.surah,
    required this.englishName,
    required this.number,
  });

  // Add method to create from JSON
  factory QuranAyah.fromJson({
    required Map<String, dynamic> arabicAyah,
    required Map<String, dynamic> translationAyah,
    required String surahName,
    required String englishName,
  }) {
    return QuranAyah(
      arabic: arabicAyah['text'],
      translation: translationAyah['text'],
      surah: surahName,
      englishName: englishName,
      number: arabicAyah['numberInSurah'].toString(),
    );
  }
}
