import 'package:flutter/material.dart';

class HistoryItemTile extends StatelessWidget {
  final dynamic item;

  const HistoryItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
    final formattedDate = "${createdAt.day}/${createdAt.month}/${createdAt.year}";
    final result = item['result'] ?? 'Résultat inconnu';
    final imageUrl = item['image_url'] ?? '';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageUrl.isNotEmpty
              ? Image.network(imageUrl, width: 56, height: 56, fit: BoxFit.cover)
              : const Icon(Icons.image_not_supported, size: 56),
        ),
        title: Text('Analyse du $formattedDate'),
        subtitle: Text(result),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Action future : afficher détails de l'analyse
        },
      ),
    );
  }
}
