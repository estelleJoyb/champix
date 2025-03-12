import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? image;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile newImage = await _controller.takePicture();
      setState(() {
        image = newImage;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking picture: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            child: Column(
            children: [
              if (image == null)
                CameraPreview(_controller),
              if(image == null)
              Padding(
                padding: const EdgeInsets.only(top : 8.0),
                child: FloatingActionButton(
                  onPressed: takePicture,
                  child: const Icon(Icons.camera_alt),
                ),
              ),
              if (image != null)
                Column(
                  children: [
                    DisplayPictureScreen(imagePath: image!.path),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          image = null;                         });
                      },
                      child: const Text('Reprendre la photo'),
                    ),
                  ],
                ),
            ],
          ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final file = File(widget.imagePath);
      if (await file.exists()) {
        setState(() {
          _imageFile = file;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Image file not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_imageFile == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Image.file(_imageFile!);
    }
  }
}
