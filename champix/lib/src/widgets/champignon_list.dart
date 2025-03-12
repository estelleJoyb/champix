import 'package:flutter/material.dart';
import 'package:champix/src/data/champignon.dart';

class ChampignonList extends StatelessWidget {
  final List<Champignon> champignons;
  final ValueChanged<Champignon>? onTap;

  const ChampignonList({required this.champignons, this.onTap, super.key});

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: champignons.length,
    itemBuilder:
        (context, index) => ListTile(
      title: Text(champignons[index].name),
      subtitle: Text(champignons[index].isEdible ? 'Comestible' : 'Non Comestible'),
      onTap: onTap != null ? () => onTap!(champignons[index]) : null,
    ),
  );
}