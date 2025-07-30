import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class DiseaseAIUtil {
  static Interpreter? _interpreter;
  static List<String>? _labels;
  static bool isInitialized = false;

  // Initialize the model and labels
  static Future<bool> initialize() async {
    try {
      if (isInitialized) return true;

      // Load the model
      _interpreter = await Interpreter.fromAsset(
        'assets/ai_modules/disease_detection_model.tflite',
      );

      // Load the labels
      final labelsData = await rootBundle.loadString(
        'assets/ai_modules/disease_detection.txt',
      );
      _labels =
          labelsData
              .split('\n')
              .map((label) => label.trim())
              .where((label) => label.isNotEmpty)
              .toList();

      isInitialized = true;
      return true;
    } catch (e) {
      print("Failed to initialize DiseaseAIUtil: $e");
      isInitialized = false;
      return false;
    }
  }

  // Classify a single image
  static Future<Map<String, dynamic>?> classifyImage(String imagePath) async {
    if (!isInitialized || _interpreter == null || _labels == null) {
      print("Error: DiseaseAIUtil is not initialized.");
      return null;
    }

    try {
      // 1. Prepare the image for the model
      final inputSize = 128;
      final imageBytes = await File(imagePath).readAsBytes();
      final decodedImage = img.decodeImage(imageBytes)!;
      final resizedImage = img.copyResize(
        decodedImage,
        width: inputSize,
        height: inputSize,
      );

      // 2. Normalize the image pixels from [0, 255] to [-1, 1]
      // This matches the preprocess_input from resnet_v2 in your notebook.
      var inputBuffer = Float32List(1 * inputSize * inputSize * 3);
      var bufferIndex = 0;
      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          final pixel = resizedImage.getPixel(x, y);
          inputBuffer[bufferIndex++] = (pixel.r / 127.5) - 1.0;
          inputBuffer[bufferIndex++] = (pixel.g / 127.5) - 1.0;
          inputBuffer[bufferIndex++] = (pixel.b / 127.5) - 1.0;
        }
      }

      // Reshape to the model's expected input shape: [1, 128, 128, 3]
      final input = inputBuffer.reshape([1, inputSize, inputSize, 3]);

      // 3. Define the output buffer
      // The model has 4 classes, so the output shape is [1, 4]
      final output = List.filled(1 * 4, 0.0).reshape([1, 4]);

      // 4. Run inference
      _interpreter!.run(input, output);

      // 5. Process the output
      final outputList = output[0] as List<double>;
      double maxScore = 0;
      int maxIndex = -1;

      for (int i = 0; i < outputList.length; i++) {
        if (outputList[i] > maxScore) {
          maxScore = outputList[i];
          maxIndex = i;
        }
      }

      if (maxIndex != -1) {
        return {'label': _labels![maxIndex], 'confidence': maxScore};
      }
      return null;
    } catch (e) {
      print("Failed to classify image with disease model: $e");
      return null;
    }
  }

  // Dispose of the interpreter to free up resources
  static void dispose() {
    if (_interpreter != null) {
      _interpreter!.close();
      _interpreter = null;
      isInitialized = false;
    }
  }
}
