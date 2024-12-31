import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quran_ayah.dart';

class ApiService {
  static const String _baseUrl = 'http://api.alquran.cloud/v1/quran';

  static Future<List<QuranAyah>> fetchQuranData() async {
    final List<QuranAyah> allAyahs = [];

    final arabicResponse = await http.get(Uri.parse('$_baseUrl/quran-uthmani'));
    final translationResponse = await http.get(Uri.parse('$_baseUrl/en.asad'));

    if (arabicResponse.statusCode == 200 &&
        translationResponse.statusCode == 200) {
      final arabicData = json.decode(arabicResponse.body);
      final translationData = json.decode(translationResponse.body);

      final arabicSurahs = arabicData['data']['surahs'];
      final translationSurahs = translationData['data']['surahs'];

      for (var i = 0; i < arabicSurahs.length; i++) {
        final arabicSurah = arabicSurahs[i];
        final translationSurah = translationSurahs[i];

        for (var j = 0; j < arabicSurah['ayahs'].length; j++) {
          allAyahs.add(QuranAyah.fromJson(
            arabicAyah: arabicSurah['ayahs'][j],
            translationAyah: translationSurah['ayahs'][j],
            surahName: arabicSurah['name'],
            englishName: translationSurah['englishName'],
          ));
        }
      }
    }

    return allAyahs;
  }
}
