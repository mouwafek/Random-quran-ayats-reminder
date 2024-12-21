import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quran App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

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
}

class MyAppState extends ChangeNotifier {
  QuranAyah? current;
  List<QuranAyah> allAyahs = [];
  var favorites = <QuranAyah>[];
  bool isLoading = true;

  MyAppState() {
    fetchAllAyahs();
  }

  Future<void> fetchAllAyahs() async {
    isLoading = true;
    notifyListeners();

    try {
      final arabicResponse = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/quran/quran-uthmani'),
      );
      final translationResponse = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/quran/en.asad'),
      );

      if (arabicResponse.statusCode == 200 && translationResponse.statusCode == 200) {
        final arabicData = json.decode(arabicResponse.body);
        final translationData = json.decode(translationResponse.body);

        final arabicSurahs = arabicData['data']['surahs'];
        final translationSurahs = translationData['data']['surahs'];

        for (var i = 0; i < arabicSurahs.length; i++) {
          final arabicSurah = arabicSurahs[i];
          final translationSurah = translationSurahs[i];

          for (var j = 0; j < arabicSurah['ayahs'].length; j++) {
            allAyahs.add(QuranAyah(
              arabic: arabicSurah['ayahs'][j]['text'],
              translation: translationSurah['ayahs'][j]['text'],
              surah: arabicSurah['name'],
              englishName: translationSurah['englishName'],
              number: arabicSurah['ayahs'][j]['numberInSurah'].toString(),
            ));
          }
        }
        getNext();
      }
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

    if (favorites.any((f) => 
        f.arabic == ayah!.arabic && 
        f.surah == ayah.surah && 
        f.number == ayah.number)) {
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = const FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appState.current == null) {
      return const Center(child: Text('No ayah loaded'));
    }

    IconData icon;
    if (appState.isFavorite(appState.current)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AyahCard(ayah: appState.current!),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          appState.toggleFavorite();
                        },
                        icon: Icon(icon),
                        label: const Text('Like'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          appState.getNext();
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AyahCard extends StatelessWidget {
  const AyahCard({
    super.key,
    required this.ayah,
  });

  final QuranAyah ayah;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              ayah.arabic,
              style: const TextStyle(fontSize: 24, fontFamily: 'Arabic'),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),
            Text(
              ayah.translation,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Surah ${ayah.surah} (${ayah.englishName}), Ayah ${ayah.number}',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Theme.of(context);

    if (appState.favorites.isEmpty) {
      return const Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have ${appState.favorites.length} favorites:'),
        ),
        Expanded(
          child: ListView(
            children: [
              for (var ayah in appState.favorites)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AyahCard(ayah: ayah),
                ),
            ],
          ),
        ),
      ],
    );
  }
}