import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class MushroomAnalysisResult {
  final String prediction;
  final double confidence;
  final Map<String, double> allProbabilities;

  MushroomAnalysisResult({
    required this.prediction,
    required this.confidence,
    required this.allProbabilities,
  });

  factory MushroomAnalysisResult.fromJson(Map<String, dynamic> json) {
    return MushroomAnalysisResult(
      prediction: json['prediction'],
      confidence: (json['confidence'] as num).toDouble(),
      allProbabilities: Map<String, double>.from(
        json['all_probabilities'].map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
    );
  }

  bool get isEdible => prediction == 'edible';
  bool get isConditionallyEdible => prediction == 'conditionally_edible';
  bool get isPoisonous => prediction == 'poisonous';
  bool get isDeadly => prediction == 'deadly';

  String get safetyMessage {
    switch (prediction) {
      case 'edible':
        return 'This mushroom seems safe to eat!';
      case 'conditionally_edible':
        return 'This mushroom is conditionally edible, please ensure proper preparation!';
      case 'poisonous':
        return 'Warning: This mushroom is poisonous! Do not consume!';
      case 'deadly':
        return 'Warning: This mushroom is deadly! Do not consume!';
      default:
        return 'Unknown mushroom type. Proceed with caution!';
    }
  }

  String get frenchPrediction {
    switch (prediction) {
      case 'edible':
        return 'Edible';
      case 'conditionally_edible':
        return 'Condionally Edible';
      case 'poisonous':
        return 'Poisonous';
      case 'deadly':
        return 'Deadly';
      default:
        return 'Unknown';
    }
  }
}

class MushroomAIService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static String? _token;

  static void setToken(String token) {
    _token = token;
  }
  
  static Future<bool> isServerAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ai/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
        return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur de connexion au serveur: $e');
      }
      return false;
    }
  }  static Future<MushroomAnalysisResult> analyzeImage(String imagePath) async {
    try {
      // Vérifier si le serveur est disponible
      if (!(await isServerAvailable())) {
        throw Exception('The AI server is not available. Please ensure the Python API is running.');
      }

     

      final uri = Uri.parse('$baseUrl/ai/predict/');
      final request = http.MultipartRequest('POST', uri);
       if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }

      if (kIsWeb) {
        // Sur le web, utiliser XFile directement
        final xFile = XFile(imagePath);
        final bytes = await xFile.readAsBytes();
        final filename = xFile.name.isNotEmpty ? xFile.name : 'image.jpg';
        
        // Déterminer le type MIME basé sur l'extension du fichier
        MediaType contentType = MediaType('image', 'jpeg'); // Par défaut
        if (filename.toLowerCase().endsWith('.png')) {
          contentType = MediaType('image', 'png');
        } else if (filename.toLowerCase().endsWith('.gif')) {
          contentType = MediaType('image', 'gif');
        } else if (filename.toLowerCase().endsWith('.webp')) {
          contentType = MediaType('image', 'webp');
        } else if (filename.toLowerCase().endsWith('.bmp')) {
          contentType = MediaType('image', 'bmp');
        } else if (filename.toLowerCase().endsWith('.jpeg') || filename.toLowerCase().endsWith('.jpg')) {
          contentType = MediaType('image', 'jpeg');
        }
        
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
          contentType: contentType, // Utiliser le type MIME détecté
        ));
      } else {
        // Sur les plateformes natives, utiliser File
        final multipartFile = await http.MultipartFile.fromPath(
          'file',
          imagePath,
        );
        
        request.files.add(multipartFile);
      }

      // Envoyer la requête
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MushroomAnalysisResult.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Server error: ${errorData['detail'] ?? 'Unknown error'}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Timeout: The image analysis took too long. Please try again.');
      }
      rethrow;
    }
  }

  static Future<MushroomAnalysisResult> analyzeImageFile(XFile imageFile) async {
    try {
      // Vérifier si le serveur est disponible
      if (!(await isServerAvailable())) {
        throw Exception('The AI server is not available. Please ensure the Python API is running.');
      }      final uri = Uri.parse('$baseUrl/ai/predict/');
      final request = http.MultipartRequest('POST', uri);
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
        // Sur toutes les plateformes, utiliser XFile.readAsBytes()
      final bytes = await imageFile.readAsBytes();
      final filename = imageFile.name.isNotEmpty ? imageFile.name : 'image.jpg';
      
      // Déterminer le type MIME basé sur l'extension du fichier
      MediaType contentType = MediaType('image', 'jpeg'); // Par défaut
      if (filename.toLowerCase().endsWith('.png')) {
        contentType = MediaType('image', 'png');
      } else if (filename.toLowerCase().endsWith('.gif')) {
        contentType = MediaType('image', 'gif');
      } else if (filename.toLowerCase().endsWith('.webp')) {
        contentType = MediaType('image', 'webp');
      } else if (filename.toLowerCase().endsWith('.bmp')) {
        contentType = MediaType('image', 'bmp');
      } else if (filename.toLowerCase().endsWith('.jpeg') || filename.toLowerCase().endsWith('.jpg')) {
        contentType = MediaType('image', 'jpeg');
      }
      
      
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: contentType,
      ));

      // Envoyer la requête
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MushroomAnalysisResult.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Server error: ${errorData['detail'] ?? 'Unknown error'}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Timeout: The image analysis took too long. Please try again.');
      }
      rethrow;
    }
  }
}
