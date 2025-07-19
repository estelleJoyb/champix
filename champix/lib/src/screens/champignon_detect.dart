import 'package:camera/camera.dart';
import 'package:champix/src/widgets/take_picture.dart';
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
  CameraDescription? camera;
  bool _isLoading = true;
  String? _error;

  void setupCamera() async {
    try {
      final cameras = await availableCameras();
      setState(() {
        if (cameras.isNotEmpty) {
          camera = cameras.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    setupCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mushroom Detection'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TakePictureScreen(
              camera: camera,
              error: _error,
            ),
    );
  }
}