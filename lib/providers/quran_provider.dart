import 'package:flutter/foundation.dart';
import '../models/quran_ayah.dart';
import '../services/api_service.dart';

class QuranProvider extends ChangeNotifier {
  QuranAyah? current;
  List<QuranAyah> allAyahs = [];
  var favorites = <QuranAyah>[];
  bool isLoading = true;

  QuranProvider() {
    fetchAllAyahs();
  }

  Future<void> fetchAllAyahs() async {
    isLoading = true;
    notifyListeners();

    try {
      final ayahs = await ApiService.fetchQuranData();
      allAyahs = ayahs;
      getNext();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading ayahs: $e');
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void getNext() {
    if (allAyahs.isEmpty) return;
    current = allAyahs[DateTime.now().millisecondsSinceEpoch % allAyahs.length];
    notifyListeners();
  }

  void toggleFavorite([QuranAyah? ayah]) {
    ayah = ayah ?? current;
    if (ayah == null) return;

    if (isFavorite(ayah)) {
      favorites.removeWhere((f) =>
          f.arabic == ayah!.arabic &&
          f.surah == ayah.surah &&
          f.number == ayah.number);
    } else {
      favorites.add(ayah);
    }
    notifyListeners();
  }

  bool isFavorite(QuranAyah? ayah) {
    if (ayah == null) return false;
    return favorites.any((f) =>
        f.arabic == ayah.arabic &&
        f.surah == ayah.surah &&
        f.number == ayah.number);
  }
}
