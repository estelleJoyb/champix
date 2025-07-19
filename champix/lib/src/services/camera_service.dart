import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _takingPicture = false;

  bool get takingPicture => _takingPicture;

  CameraController? get controller => _controller;

  Future<void>? get initializeControllerFuture => _initializeControllerFuture;

  void initializeCamera(CameraDescription camera) {
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller!.initialize();
  }

  Future<XFile?> takePicture() async {
    if (_controller == null || _initializeControllerFuture == null) return null;

    _takingPicture = true;
    try {
      await _initializeControllerFuture!;
      final newImage = await _controller!.takePicture();
      _takingPicture = false;
      return newImage;
    } catch (e) {
      _takingPicture = false;
      rethrow;
    }
  }

  void dispose() {
    _controller?.dispose();
  }
}