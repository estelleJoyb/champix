import 'package:flutter/material.dart';

class ChampignonDetectScreen extends StatefulWidget {
  const ChampignonDetectScreen({
    super.key,
  });

  @override
  State<ChampignonDetectScreen> createState() => _ChampignonDetectScreenState();
}

class _ChampignonDetectScreenState extends State<ChampignonDetectScreen>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détection Champignons'),
      ),
      body: Text("detecting ..."),

    );
  }

}