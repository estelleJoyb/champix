import 'package:flutter/material.dart';
import '../services/mushroom_ai_service.dart';

class AnalysisResultWidget extends StatelessWidget {
  final MushroomAnalysisResult result;

  const AnalysisResultWidget({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color getResultColor() {
      switch (result.prediction) {
        case 'edible':
          return Colors.green;
        case 'conditionally_edible':
          return Colors.orange;
        case 'poisonous':
          return Colors.red;
        case 'deadly':
          return Colors.red.shade900;
        default:
          return Colors.grey;
      }
    }

    IconData getResultIcon() {
      switch (result.prediction) {
        case 'edible':
          return Icons.check_circle;
        case 'conditionally_edible':
          return Icons.warning;
        case 'poisonous':
          return Icons.dangerous;
        case 'deadly':
          return Icons.error;
        default:
          return Icons.help;
      }
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              'Résultat de l\'analyse',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Résultat principal
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: getResultColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: getResultColor(), width: 2),
              ),
              child: Row(
                children: [
                  Icon(
                    getResultIcon(),
                    color: getResultColor(),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.frenchPrediction,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: getResultColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Confiance: ${(result.confidence * 100).toStringAsFixed(1)}%',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Message de sécurité
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      result.safetyMessage,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Détails des probabilités
            ExpansionTile(
              title: const Text('Détails des probabilités'),
              children: [
                ...result.allProbabilities.entries.map((entry) {
                  final percentage = (entry.value * 100);
                  String frenchLabel;
                  switch (entry.key) {
                    case 'edible':
                      frenchLabel = 'Comestible';
                      break;
                    case 'conditionally_edible':
                      frenchLabel = 'Conditionnellement comestible';
                      break;
                    case 'poisonous':
                      frenchLabel = 'Toxique';
                      break;
                    case 'deadly':
                      frenchLabel = 'Mortel';
                      break;
                    default:
                      frenchLabel = entry.key;
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(frenchLabel),
                        ),
                        Expanded(
                          flex: 2,
                          child: LinearProgressIndicator(
                            value: entry.value,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              percentage > 50 ? getResultColor() : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${percentage.toStringAsFixed(1)}%'),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Avertissement
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cette analyse est basée sur l\'intelligence artificielle et ne doit pas remplacer l\'expertise d\'un mycologue professionnel. Ne jamais consommer un champignon sans être absolument certain de son identification.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
