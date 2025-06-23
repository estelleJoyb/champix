import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/mushroom_ai_service.dart';
import 'analysis_result_widget.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, this.camera, this.error});

  final CameraDescription? camera;
  final String? error;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool takingPicture = false;
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.camera != null) {
      _controller = CameraController(
        widget.camera!,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize();
    }
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }  void takePicture() async {
    if (_controller == null || _initializeControllerFuture == null) return;
    
    setState(() {
      takingPicture = true;
    });
    try {
      await _initializeControllerFuture!;
      final XFile newImage = await _controller!.takePicture();
      setState(() {
        takingPicture = false;
        image = newImage;
      });
    } catch (e) {
      setState(() {
        takingPicture = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking picture: $e')),
        );
      }
    }
  }
  void pickImageFromGallery() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          image = pickedImage;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }  @override
  Widget build(BuildContext context) {
    // Si une image est sélectionnée, l'afficher avec les options
    if (image != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            DisplayPictureScreen(imageFile: image!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      image = null;
                    });
                  },
                  child: const Text('Changer d\'image'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnalysisScreen(imageFile: image!),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Analyser'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Si il y a une erreur avec la caméra, afficher seulement l'option galerie
    if (widget.error != null) {
      return _buildGalleryOnlyInterface();
    }

    // Si pas de caméra disponible, afficher seulement l'option galerie
    if (widget.camera == null) {
      return _buildGalleryOnlyInterface();
    }

    // Si la caméra est disponible, utiliser FutureBuilder
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return _buildGalleryOnlyInterface();
          }
          return _buildCameraInterface();
        } else {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initialisation de la caméra...'),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildGalleryOnlyInterface() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.photo_library,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Caméra non disponible',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Sélectionnez une photo depuis votre galerie',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: pickImageFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('Choisir une photo'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
          if (widget.error != null) ...[
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Erreur caméra: ${widget.error}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCameraInterface() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CameraPreview(_controller!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FloatingActionButton(
                  onPressed: takingPicture ? null : takePicture,
                  heroTag: "camera",
                  child: const Icon(Icons.camera_alt),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FloatingActionButton(
                  onPressed: pickImageFromGallery,
                  heroTag: "gallery",
                  child: const Icon(Icons.photo_library),
                ),
              ),
            ],
          ),
        ],
      ),
    );  }
}

class DisplayPictureScreen extends StatefulWidget {
  final XFile imageFile;

  const DisplayPictureScreen({super.key, required this.imageFile});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  Uint8List? _imageBytes;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }
  Future<void> _loadImage() async {
    try {
      // Sur toutes les plateformes, utiliser XFile.readAsBytes()
      final bytes = await widget.imageFile.readAsBytes();
      if (mounted) {
        setState(() {
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading image: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      // Afficher le message d'erreur maintenant que le context est disponible
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_errorMessage!)),
          );
        }
      });
      
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    if (_imageBytes == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Image.memory(
        _imageBytes!,
        fit: BoxFit.contain,
      );
    }
  }
}

class AnalysisScreen extends StatefulWidget {
  final XFile imageFile;

  const AnalysisScreen({super.key, required this.imageFile});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool _isAnalyzing = false;
  MushroomAnalysisResult? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }  Future<void> _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await MushroomAIService.analyzeImageFile(widget.imageFile);
      setState(() {
        _result = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse du Champignon'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [            // Afficher l'image
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FutureBuilder<Uint8List>(
                  future: widget.imageFile.readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),

            // État de l'analyse
            if (_isAnalyzing)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Analyse en cours...'),
                    Text('Cela peut prendre quelques secondes.'),
                  ],
                ),
              ),

            // Erreur
            if (_error != null)
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    const Text(
                      'Erreur d\'analyse',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _analyzeImage,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),

            // Résultat
            if (_result != null)
              AnalysisResultWidget(result: _result!),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
