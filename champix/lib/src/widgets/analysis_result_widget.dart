import 'package:flutter/material.dart';
import '../services/mushroom_ai_service.dart';

class AnalysisResultWidget extends StatefulWidget {
  final MushroomAnalysisResult result;

  const AnalysisResultWidget({super.key, required this.result});

  @override
  State<AnalysisResultWidget> createState() => _AnalysisResultWidgetState();
}

class _AnalysisResultWidgetState extends State<AnalysisResultWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Color getResultColor() {
    switch (widget.result.prediction) {
      case 'edible':
        return const Color(0xFF4CAF50);
      case 'conditionally_edible':
        return const Color(0xFFFF9800);
      case 'poisonous':
        return const Color(0xFFFF5722);
      case 'deadly':
        return const Color(0xFFB71C1C);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData getResultIcon() {
    switch (widget.result.prediction) {
      case 'edible':
        return Icons.check_circle_rounded;
      case 'conditionally_edible':
        return Icons.warning_amber_rounded;
      case 'poisonous':
        return Icons.dangerous_rounded;
      case 'deadly':
        return Icons.error_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String getResultEmoji() {
    switch (widget.result.prediction) {
      case 'edible':
        return '✅';
      case 'conditionally_edible':
        return '⚠️';
      case 'poisonous':
        return '☠️';
      case 'deadly':
        return '💀';
      default:
        return '❓';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resultColor = getResultColor();

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A0A0A),
              const Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF2D2D2D),
                          const Color(0xFF1F1F1F),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: resultColor.withOpacity(0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: resultColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: Column(
                        children: [
                          // Header avec gradient moderne
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  resultColor.withOpacity(0.2),
                                  resultColor.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                topRight: Radius.circular(24.0),
                              ),
                            ),
                            child: Column(children: [
                              // Icône et emoji avec effet néon
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      resultColor.withOpacity(0.3),
                                      resultColor.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: resultColor.withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3A3A3A),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: resultColor.withOpacity(0.6),
                                      width: 2,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        getResultIcon(),
                                        size: 45,
                                        color: resultColor,
                                      ),
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            getResultEmoji(),
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Titre principal avec style moderne
                              Text(
                                widget.result.frenchPrediction,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: resultColor.withOpacity(0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 8),

                              // Barre de confiance glassmorphism
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.15),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.analytics_rounded,
                                      size: 18,
                                      color: resultColor,
                                    ),
                                    const SizedBox(
                                        width:
                                            10), // Moved Container(width: 10) here as SizedBox
                                    Text(
                                      'Confiance: ${(widget.result.confidence * 100).toStringAsFixed(1)}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Contenu principal
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Message de sécurité avec glassmorphism
                                    Container(
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.blue.withOpacity(0.15),
                                            Colors.purple.withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 15,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.blue.withOpacity(0.3),
                                                  Colors.blue.withOpacity(0.1),
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.blue
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.info_outline_rounded,
                                              color: Colors.lightBlueAccent,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  16), // Fixed: Replaced incorrect Container(width: 10)
                                          Expanded(
                                            child: Text(
                                              widget.result.safetyMessage,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Bouton pour les détails - style moderne
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                resultColor.withOpacity(0.3),
                                                resultColor.withOpacity(0.1),
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.analytics_outlined,
                                            color: resultColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            'Détails des probabilités',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        AnimatedRotation(
                                          turns: _isExpanded ? 0.5 : 0.0,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: Icon(
                                            Icons.expand_more_rounded,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Détails des probabilités avec animation
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                height: _isExpanded ? null : 0,
                                child: _isExpanded
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 18),
                                        padding: const EdgeInsets.all(22),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white.withOpacity(0.08),
                                              Colors.white.withOpacity(0.03),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.15),
                                          ),
                                        ),
                                        child: Column(
                                          children: widget
                                              .result.allProbabilities.entries
                                              .map((entry) {
                                            final percentage =
                                                (entry.value * 100);
                                            String frenchLabel;
                                            Color barColor;

                                            switch (entry.key) {
                                              case 'edible':
                                                frenchLabel = 'Comestible';
                                                barColor =
                                                    const Color(0xFF4CAF50);
                                                break;
                                              case 'conditionally_edible':
                                                frenchLabel =
                                                    'Conditionnellement comestible';
                                                barColor =
                                                    const Color(0xFFFF9800);
                                                break;
                                              case 'poisonous':
                                                frenchLabel = 'Toxique';
                                                barColor =
                                                    const Color(0xFFFF5722);
                                                break;
                                              case 'deadly':
                                                frenchLabel = 'Mortel';
                                                barColor =
                                                    const Color(0xFFB71C1C);
                                                break;
                                              default:
                                                frenchLabel = entry.key;
                                                barColor =
                                                    const Color(0xFF9E9E9E);
                                            }

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        frenchLabel,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: barColor
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                            color: barColor
                                                                .withOpacity(
                                                                    0.4),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          '${percentage.toStringAsFixed(1)}%',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: barColor,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: entry.value,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                barColor),
                                                        minHeight: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )
                                    : null,
                              ),

                              const SizedBox(height: 24),

                              Container(
                                padding: const EdgeInsets.all(22.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.orange.withOpacity(0.15),
                                      Colors.red.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(18.0),
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.4),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.orange.withOpacity(0.3),
                                            Colors.orange.withOpacity(0.1),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.orange.withOpacity(0.6),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.orange.withOpacity(0.3),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.orange,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Avertissement Important',
                                            style: theme.textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amber.shade800,
                                                ) ??
                                                TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amber.shade800,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Cette analyse est basée sur l\'intelligence artificielle et ne doit pas remplacer l\'expertise d\'un mycologue professionnel. Ne jamais consommer un champignon sans être absolument certain de son identification.',
                                            style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: Colors.amber.shade800,
                                                  height: 1.4,
                                                ) ??
                                                TextStyle(
                                                  color: Colors.amber.shade800,
                                                  fontSize: 14,
                                                  height: 1.4,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    )))));
  }
}
