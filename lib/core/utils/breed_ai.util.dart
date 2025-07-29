import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class BreedAIUtil {
  static Interpreter? _interpreter;
  static List<String>? _labels;
  static bool _isInitialized = false;

  // Initialize the model (load interpreter and labels)
  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      debugPrint("Starting to load TensorFlow Lite model...");

      // Load the TensorFlow Lite model
      _interpreter = await Interpreter.fromAsset(
        'assets/ai_modules/dog_breed_model.tflite',
      );
      debugPrint(
        "Model interpreter loaded successfully from: assets/ai_modules/dog_breed_model.tflite",
      );

      // Load labels
      debugPrint("Loading labels from: assets/ai_modules/labels.txt");
      final labelsData = await rootBundle.loadString(
        'assets/ai_modules/labels.txt',
      );
      _labels =
          labelsData.split('\n').where((label) => label.isNotEmpty).toList();
      debugPrint("Labels loaded successfully with ${_labels?.length} labels");

      debugPrint("Model setup complete!");
      if (_labels != null && _labels!.isNotEmpty) {
        debugPrint("First few labels: ${_labels?.take(5).join(', ')}");
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint("Error loading model: $e");
      debugPrint("Stack trace: ${StackTrace.current}");

      // Reset variables on error
      _interpreter = null;
      _labels = null;
      _isInitialized = false;
      return false;
    }
  }

  // Preprocess image for model input
  static Float32List preprocessImage(String imagePath) {
    final imageFile = File(imagePath);
    final image = img.decodeImage(imageFile.readAsBytesSync())!;

    // Resize image to model input size (typically 224x224 for most models)
    final resized = img.copyResize(image, width: 224, height: 224);

    // Convert to Float32List and normalize
    final input = Float32List(1 * 224 * 224 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        input[pixelIndex++] = pixel.r / 255.0;
        input[pixelIndex++] = pixel.g / 255.0;
        input[pixelIndex++] = pixel.b / 255.0;
      }
    }

    return input;
  }

  // Classify image and return breed prediction
  static Future<Map<String, dynamic>?> classifyImage(String imagePath) async {
    if (_interpreter == null || _labels == null) {
      debugPrint("Model not loaded");
      return null;
    }

    try {
      // Input is now the correctly formatted Float32List
      final Float32List input = preprocessImage(imagePath);

      final outputTensor = _interpreter!.getOutputTensor(0);
      final outputShape = outputTensor.shape;
      final numClasses = outputShape.last;

      debugPrint("Model output shape: $outputShape");
      debugPrint("Number of classes from model: $numClasses");
      debugPrint("Number of labels loaded: ${_labels!.length}");

      final output = Float32List(numClasses).reshape([1, numClasses]);

      // Pass the input directly to the interpreter
      _interpreter!.run(input.reshape([1, 224, 224, 3]), output);

      debugPrint("Raw model output: ${output.first}");

      // Find the class with highest confidence
      double maxConfidence = -1;
      int maxIndex = -1;

      // We search in output.first because output shape is [1, 120]
      for (int i = 0; i < output.first.length; i++) {
        if (output.first[i] > maxConfidence) {
          maxConfidence = output.first[i];
          maxIndex = i;
        }
      }

      if (maxIndex == -1 || maxConfidence <= 0.0) {
        debugPrint("No confident prediction found.");
        return {'label': 'Unknown', 'confidence': 0.0};
      }

      if (maxIndex >= _labels!.length) {
        debugPrint(
          "Warning: Predicted class index ($maxIndex) exceeds available labels (${_labels!.length})",
        );
        return {
          'label': 'Unknown (index: $maxIndex)',
          'confidence': maxConfidence,
        };
      }

      return {'label': _labels![maxIndex], 'confidence': maxConfidence};
    } catch (e) {
      debugPrint("Error during classification: $e");
      return null;
    }
  }

  // Cleanup resources
  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
    _isInitialized = false;
  }

  // Check if model is initialized
  static bool get isInitialized => _isInitialized;
}
