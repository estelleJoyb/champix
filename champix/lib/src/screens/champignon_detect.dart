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

  void setupCamera() async {
    final cameras = await availableCameras();
    setState(() {
      print("camera !!");
      camera = cameras.first;
    });
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
        title: const Text('Identifier un Champignon'),
      ),
      body: camera != null ? TakePictureScreen(camera: camera!,) : const Center(child: CircularProgressIndicator()),

    );


  }

}