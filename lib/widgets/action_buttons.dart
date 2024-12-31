import 'package:flutter/material.dart';
import '../providers/quran_provider.dart';

class ActionButtons extends StatelessWidget {
  final QuranProvider provider;

  const ActionButtons({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    IconData icon = provider.isFavorite(provider.current)
        ? Icons.favorite
        : Icons.favorite_border;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            provider.toggleFavorite();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
          ),
          icon: Icon(icon),
          label: const Text(
            'Save',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            provider.getNext();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
          ),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text(
            'Next Ayah',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
