import 'dart:convert';

import 'package:champix/src/services/mushroom_ai_service.dart';
import 'package:champix/src/widgets/analysis_result_widget.dart';
import 'package:flutter/material.dart';

class AllHistoryScreen extends StatelessWidget {
  final List<dynamic> history;

  const AllHistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Analyses History"),
        backgroundColor: Colors.black,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: history.isEmpty
          ? Center(
              child: Text(
                "No history available",
                style:
                    theme.textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final createdAt = DateTime.tryParse(item['created_at'] ?? '') ??
                    DateTime.now();
                final date =
                    '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
                final result = item['result'] ?? 'Résultat inconnu';
                final imageUrl = item['image_path'] ?? '';

                final detailJson = jsonDecode(item['analyse_detail']);
                final analyseDetail = MushroomAnalysisResult.fromJson(detailJson);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(
                              backgroundColor: theme.colorScheme.surface,
                              elevation: 0,
                              title: const Text('Analysis Result'),
                            ),
                            body: AnalysisResultWidget(
                              result: analyseDetail,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'history_image_$index',
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: theme.colorScheme.surfaceVariant,
                                        width: 100,
                                        height: 100,
                                        child: Icon(Icons.broken_image,
                                            color: theme.colorScheme.primary),
                                      ),
                                    )
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      color: theme.colorScheme.surface,
                                      child: Icon(Icons.camera_alt_outlined,
                                          color: theme.colorScheme.primary),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Analysis $date',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    result,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.chevron_right,
                              size: 24,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
