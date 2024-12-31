import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../widgets/ayah_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<QuranProvider>();

    if (provider.favorites.isEmpty) {
      return const Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have ${provider.favorites.length} favorites:'),
        ),
        Expanded(
          child: ListView(
            children: [
              for (var ayah in provider.favorites)
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
