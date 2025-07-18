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
        return 'Ce champignon semble comestible';
      case 'conditionally_edible':
        return 'Ce champignon est comestible sous certaines conditions. Soyez prudent!';
      case 'poisonous':
        return 'ATTENTION: Ce champignon semble toxique!';
      case 'deadly':
        return 'DANGER: Ce champignon semble mortel! Ne pas consommer!';
      default:
        return 'Classification inconnue';
    }
  }

  String get frenchPrediction {
    switch (prediction) {
      case 'edible':
        return 'Comestible';
      case 'conditionally_edible':
        return 'Conditionnellement comestible';
      case 'poisonous':
        return 'Toxique';
      case 'deadly':
        return 'Mortel';
      default:
        return 'Inconnu';
    }
  }
}

class MushroomAIService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  
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
        throw Exception('Le serveur d\'IA n\'est pas disponible. Assurez-vous que l\'API Python est en cours d\'exécution.');
      }

      final uri = Uri.parse('$baseUrl/ai/predict/');
      final request = http.MultipartRequest('POST', uri);
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
        
        print('Envoi du fichier: $filename avec type MIME: ${contentType.toString()}');
        print('Taille du fichier: ${bytes.length} bytes');
        
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
        print('Envoi du fichier: ${multipartFile.filename} avec type MIME: ${multipartFile.contentType}');
        print('Taille du fichier: ${multipartFile.length} bytes');
        
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
        throw Exception('Erreur du serveur: ${errorData['detail'] ?? 'Erreur inconnue'}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Timeout: L\'analyse de l\'image a pris trop de temps. Veuillez réessayer.');
      }
      rethrow;
    }
  }

  static Future<MushroomAnalysisResult> analyzeImageFile(XFile imageFile) async {
    try {
      // Vérifier si le serveur est disponible
      if (!(await isServerAvailable())) {
        throw Exception('Le serveur d\'IA n\'est pas disponible. Assurez-vous que l\'API Python est en cours d\'exécution.');
      }      final uri = Uri.parse('$baseUrl/ai/predict/');
      final request = http.MultipartRequest('POST', uri);
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
      
      print('Envoi du fichier: $filename avec type MIME: ${contentType.toString()}');
      print('Taille du fichier: ${bytes.length} bytes');
      
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: contentType, // Utiliser le type MIME détecté
      ));

      // Envoyer la requête
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MushroomAnalysisResult.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Erreur du serveur: ${errorData['detail'] ?? 'Erreur inconnue'}');
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Timeout: L\'analyse de l\'image a pris trop de temps. Veuillez réessayer.');
      }
      rethrow;
    }
  }
}
